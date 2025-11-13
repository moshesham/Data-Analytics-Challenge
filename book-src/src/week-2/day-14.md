# Day 14: Weaving the Narrative – Quant + Qual

## Overview

**Objective:** To combine quantitative metrics with qualitative user feedback to create a holistic and deeply empathetic understanding of the user experience.

**Why This Matters:** Numbers tell you *what* users do; words tell you *how they feel*. The most powerful insights lie at the intersection of both. This skill separates a data reporter from a true product strategist.

## The Power of Integration

### What Quantitative Data Tells You

- **What happened:** "60% of users dropped off at Step 3"
- **How many:** "27,000 users affected"
- **Statistical significance:** "p < 0.001, highly significant"
- **Patterns:** "iOS users convert 15% better than Android"

### What Qualitative Data Tells You

- **Why it happened:** "Users didn't see the icon because..."
- **How users feel:** "Frustrated," "Delighted," "Confused"
- **Unexpected insights:** "I use it for grief journaling, not what you designed for"
- **Language users use:** "Private space," "My thoughts," "Safe place"

### The Magic of Synthesis

When combined, quantitative + qualitative answers:
- **What's broken AND why it's broken**
- **What's working AND why users love it**
- **What to build next AND how to describe it**

## The Scenario

You have two data sources:

1. **Quantitative (from Day 10):** 60% funnel drop-off between viewing feed and tapping icon
2. **Qualitative:** 500 user comments about the Journals feature from in-app feedback and app store reviews

Your job: Find the story that connects them.

## Task 1: Load and Categorize Qualitative Data

### Simple NLP-Based Categorization

```python
import pandas as pd
import re
from collections import Counter

def load_and_clean_feedback(filepath='feedback.csv'):
    """
    Load user feedback and perform basic cleaning
    """
    df = pd.read_csv(filepath)
    
    # Clean text
    df['comment_clean'] = df['comment'].str.lower()
    df['comment_clean'] = df['comment_clean'].str.replace(r'[^\w\s]', '', regex=True)
    
    return df

def categorize_feedback(comment):
    """
    Categorize a comment into predefined themes
    
    Returns: list of applicable categories
    """
    comment = comment.lower()
    categories = []
    
    # Define keyword patterns for each category
    bug_keywords = ['crash', 'broken', 'error', 'bug', 'doesnt work', "doesn't work", 
                    'not working', 'freeze', 'slow']
    feature_request_keywords = ['wish', 'would be nice', 'please add', 'need', 'want', 
                                'should have', 'missing', 'add feature']
    praise_keywords = ['love', 'amazing', 'great', 'awesome', 'fantastic', 'excellent', 
                      'thank you', 'finally', 'perfect']
    privacy_keywords = ['privacy', 'private', 'secure', 'security', 'safe', 'encryption', 
                       'data', 'share', 'access']
    discovery_keywords = ['find', 'found', 'discover', 'hidden', 'didnt know', "didn't know",
                         'where is', 'how to', 'cant find', "can't find"]
    
    if any(word in comment for word in bug_keywords):
        categories.append('Bug Report')
    if any(word in comment for word in feature_request_keywords):
        categories.append('Feature Request')
    if any(word in comment for word in praise_keywords):
        categories.append('Praise')
    if any(word in comment for word in privacy_keywords):
        categories.append('Privacy Concern')
    if any(word in comment for word in discovery_keywords):
        categories.append('Discovery Issue')
    
    # Default to "Other" if no categories matched
    if not categories:
        categories.append('Other')
    
    return categories

def analyze_feedback_themes(df):
    """
    Analyze feedback and return theme counts
    """
    all_categories = []
    
    for comment in df['comment_clean']:
        categories = categorize_feedback(comment)
        all_categories.extend(categories)
    
    theme_counts = Counter(all_categories)
    
    return pd.DataFrame({
        'theme': list(theme_counts.keys()),
        'count': list(theme_counts.values())
    }).sort_values('count', ascending=False)

# Usage
df_feedback = load_and_clean_feedback('feedback.csv')
theme_summary = analyze_feedback_themes(df_feedback)
print(theme_summary)
```

### Advanced: Sentiment Analysis

```python
from textblob import TextBlob

def analyze_sentiment(comment):
    """
    Perform sentiment analysis on a comment
    
    Returns: sentiment score (-1 to 1) and classification
    """
    blob = TextBlob(comment)
    sentiment_score = blob.sentiment.polarity
    
    if sentiment_score > 0.1:
        sentiment_class = 'Positive'
    elif sentiment_score < -0.1:
        sentiment_class = 'Negative'
    else:
        sentiment_class = 'Neutral'
    
    return sentiment_score, sentiment_class

def add_sentiment_to_feedback(df):
    """
    Add sentiment columns to feedback dataframe
    """
    df['sentiment_score'], df['sentiment_class'] = zip(*df['comment'].apply(analyze_sentiment))
    return df

# Analyze sentiment by theme
df_feedback = add_sentiment_to_feedback(df_feedback)

sentiment_by_theme = df_feedback.groupby('primary_theme').agg({
    'sentiment_score': 'mean',
    'comment': 'count'
}).rename(columns={'comment': 'count'})

print(sentiment_by_theme)
```

## Task 2: Quantify Themes

Create a visualization showing the distribution of feedback themes.

```python
import matplotlib.pyplot as plt
import seaborn as sns

def visualize_feedback_themes(theme_summary):
    """
    Create a bar chart of feedback themes
    """
    fig, ax = plt.subplots(figsize=(12, 6))
    
    # Sort by count
    theme_summary = theme_summary.sort_values('count', ascending=True)
    
    # Define colors for each theme
    color_map = {
        'Praise': '#4CAF50',
        'Feature Request': '#2196F3',
        'Bug Report': '#F44336',
        'Privacy Concern': '#FF9800',
        'Discovery Issue': '#9C27B0',
        'Other': '#9E9E9E'
    }
    
    colors = [color_map.get(theme, '#9E9E9E') for theme in theme_summary['theme']]
    
    bars = ax.barh(theme_summary['theme'], theme_summary['count'], color=colors, alpha=0.8)
    
    # Add value labels
    for i, bar in enumerate(bars):
        width = bar.get_width()
        ax.text(width, bar.get_y() + bar.get_height()/2, 
               f' {int(width)} ({int(width)/theme_summary["count"].sum()*100:.1f}%)',
               ha='left', va='center', fontsize=10, fontweight='bold')
    
    ax.set_xlabel('Number of Comments', fontsize=12, fontweight='bold')
    ax.set_title('User Feedback Themes: Journals Feature (Week 1)\nn=500 comments', 
                fontsize=14, fontweight='bold')
    ax.grid(axis='x', alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('feedback_themes.png', dpi=300, bbox_inches='tight')
    return fig

# Create visualization
visualize_feedback_themes(theme_summary)
```

### Extract Representative Quotes

```python
def extract_representative_quotes(df, theme, n=5, min_length=50):
    """
    Extract the most representative quotes for a given theme
    
    Uses sentiment score and length as proxy for quality
    """
    # Filter to theme
    theme_comments = df[df['comment_clean'].apply(
        lambda x: theme.lower() in ' '.join(categorize_feedback(x)).lower()
    )].copy()
    
    # Add comment length
    theme_comments['length'] = theme_comments['comment'].str.len()
    
    # Filter by minimum length
    theme_comments = theme_comments[theme_comments['length'] >= min_length]
    
    # Sort by absolute sentiment (strongest opinions)
    theme_comments['abs_sentiment'] = theme_comments['sentiment_score'].abs()
    theme_comments = theme_comments.sort_values('abs_sentiment', ascending=False)
    
    return theme_comments[['comment', 'sentiment_score', 'sentiment_class']].head(n)

# Example: Get representative "Discovery Issue" quotes
discovery_quotes = extract_representative_quotes(df_feedback, 'Discovery Issue')
for idx, row in discovery_quotes.iterrows():
    print(f"[{row['sentiment_class']}] {row['comment']}\n")
```

## Task 3: Find the Connection

Look for patterns where qualitative data explains, contradicts, or adds nuance to quantitative findings.

### The Synthesis Framework

**Step 1: State the Quantitative Finding**
"Our funnel analysis showed a 60% drop-off between viewing the main feed and tapping the Journals icon."

**Step 2: Ask "Why?" and Look to Qualitative**
Search feedback for keywords: "find," "discover," "didn't know," "where is"

**Step 3: Find Supporting Evidence**
Extract quotes that explain the quantitative pattern

**Step 4: Synthesize into Insight**
Combine both into a unified narrative

## Task 4: Write the Synthesized Insight

In notebook `14_qualitative_analysis.ipynb`, create the synthesis.

### The Synthesis Template

```markdown
# Qualitative-Quantitative Synthesis: The Discovery Problem

## Executive Summary

Our quantitative funnel analysis revealed a critical 60% drop-off point. Our 
qualitative feedback analysis explains *why*: users want the feature but 
literally can't find it. This is not a value problem—it's a design problem.

---

## The Quantitative Signal

**Finding (from Day 10 Funnel Analysis):**
- 60% of users (27,000 per week) drop off between viewing the main feed and 
  tapping the Journals icon
- This represents the single largest friction point in our adoption journey
- Users who DO find the icon convert at 67% (strong value signal)

**What This Told Us:**
Something is preventing the majority of interested users from taking the next step. 
But the data couldn't tell us *what* or *why*.

---

## The Qualitative Context

**Finding (from Week 1 User Feedback Analysis):**

**Theme Distribution (n=500 comments):**
- Praise: 28% (140 comments)
- Discovery Issues: 22% (110 comments) ⚠️
- Feature Requests: 20% (100 comments)
- Privacy Concerns: 15% (75 comments)
- Bug Reports: 10% (50 comments)
- Other: 5% (25 comments)

**Key Insight:** "Discovery Issues" is the 2nd largest feedback category, despite 
the feature being only 1 week old.

---

## The Synthesis: What the Words Reveal

### Representative Quotes (Discovery Issues Theme)

**1. The "I Finally Found It" Pattern**

> "I love this feature but it took me 3 days to even find it! The icon blends 
> into the background. Please make it more visible!"  
> — User A, iOS, Sentiment: Positive

> "This is exactly what I've been wanting, but I only discovered it because my 
> friend told me about it. I would have never found it on my own."  
> — User B, Android, Sentiment: Neutral

**What This Tells Us:** Users who find the feature love it (validates value), but 
many rely on external discovery (friends, social media, luck) rather than in-app UX.

---

**2. The "I Wish I Knew Sooner" Pattern**

> "I've been using this app for 2 years and just found out about Journals today. 
> Why wasn't this more prominent??"  
> — User C, iOS, Sentiment: Frustrated

> "Love it now that I found it, but wish I'd known about it from day 1. Feels 
> hidden."  
> — User D, Android, Sentiment: Positive (but frustrated)

**What This Tells Us:** The feature's value proposition is strong (users use words 
like "love," "exactly what I needed"), but the pain point is discoverability, not 
desirability.

---

**3. The "Where Is It?" Pattern**

> "I saw a screenshot on Twitter but can't figure out how to access this feature. 
> Is it only for premium users?"  
> — User E, iOS, Sentiment: Confused

> "Spent 10 minutes looking for the 'journal' feature everyone's talking about. 
> Finally found the tiny icon. Make it bigger!"  
> — User F, Android, Sentiment: Negative

**What This Tells Us:** Users are actively searching for the feature (high intent) 
but failing to locate it through normal app navigation.

---

## The Integrated Insight

### What Quantitative Data Alone Would Have Told Us:
"There's a 60% drop-off in the funnel at Step 3. Users aren't tapping the icon."

**Possible Interpretations:**
- Users don't want the feature (value problem) ❌
- The icon is confusing (comprehension problem) ❌
- Users can't see the icon (visibility problem) ✅

### What Qualitative Data Adds:
"Of the users who DO find the feature, 80%+ express phrases like 'I love this,' 
'exactly what I needed,' or 'wish I found it sooner.'"

**This rules out the first two interpretations.** Users want the feature. The 
icon makes sense once clicked. The problem is **visibility**.

---

## The Unified Story

**The Complete Narrative:**

Our quantitative funnel analysis identified a 60% drop-off between viewing the 
feed and tapping the Journals icon—a massive leak affecting 27,000 users per week.

**Qualitative feedback reveals the "why" behind this number:** The feature has 
strong product-market fit (28% of comments are praise), but a critical UX failure 
is hiding it from users who actively want it.

**Evidence:**
- **22% of all feedback** is about discovery problems (2nd largest category)
- **80%+ of "Discovery Issue" comments** contain positive sentiment about the 
  feature itself
- Users use phrases like "finally found," "wish I knew sooner," and "why is this 
  hidden?"

**This isn't a feature failure—it's a design failure.** The icon's current 
placement, size, and color are failing to capture user attention in the busy 
feed environment.

---

## The Power of This Synthesis

### What We Now Know (That We Couldn't Know from Either Data Source Alone):

1. **The feature has strong PMF** (qualitative: "love," "exactly what I needed")
2. **The bottleneck is discoverability** (quantitative: 60% funnel drop)
3. **Users WANT to find it** (qualitative: "spent 10 minutes looking")
4. **The icon design is the problem** (synthesis of both)

### What This Means for Product Strategy:

**Priority 1:** Fix icon visibility (high confidence, high impact)
- Not a feature problem, so no roadmap change needed
- Not a value problem, so messaging is working
- Pure UX fix: make it bigger, brighter, more prominent

**Expected Impact:**
- If icon redesign improves tap-through rate from 40% to 80% (plausible based on 
  benchmark data), we add 18,000 adopters per week
- Qualitative feedback suggests this won't cannibalize feed time (users see them 
  as complementary, not competitive)

---

## Quantitative-Qualitative Cross-Validation

### Finding: Praise Sentiment Despite Low Discovery

**Quantitative:** Only 36% of users tap the icon (low discovery rate)

**Qualitative:** 28% of comments are praise (highest category)

**Synthesis:** The small subset of users who discover the feature become passionate 
advocates. This is a strong signal that solving the discovery problem will unlock 
significant value.

### Finding: No Privacy Backlash (Guardrail Check)

**Quantitative:** Uninstall rate flat at 0.23% (no spike)

**Qualitative:** Privacy concerns represent only 15% of feedback (and are mostly 
questions, not complaints)

**Synthesis:** Our privacy messaging and data handling are adequate. No need to 
deprioritize feature work to address privacy concerns.

---

## Conclusion

This analysis demonstrates the irreplaceable value of combining quantitative and 
qualitative data:

- **Quantitative** showed us WHERE the problem is (60% funnel drop at Step 3)
- **Qualitative** showed us WHY it's happening (users can't find the icon)
- **Synthesis** showed us WHAT TO DO (fix icon visibility, not feature value)

**Without qualitative:** We might have concluded users don't want the feature and 
killed it.

**Without quantitative:** We might have missed the scale of the problem (27K users 
affected).

**Together:** We have a clear, actionable, high-confidence recommendation that 
addresses root cause, not symptoms.

---

## Recommended Action

**Design an A/B test for icon redesign** (already prioritized in Week 1 memo) with 
confidence that:
1. The feature has proven value (qualitative validation)
2. The bottleneck is specific and fixable (quantitative isolation)
3. Users actively want better access (qualitative demand signal)

**This is the power of synthesis.**
```

## Advanced Technique: Topic Modeling

For larger datasets, use machine learning to discover themes:

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import LatentDirichletAllocation

def perform_topic_modeling(comments, n_topics=5, n_words=10):
    """
    Use LDA to discover hidden topics in feedback
    """
    # Vectorize comments
    vectorizer = TfidfVectorizer(max_features=1000, stop_words='english')
    doc_term_matrix = vectorizer.fit_transform(comments)
    
    # Fit LDA model
    lda = LatentDirichletAllocation(n_components=n_topics, random_state=42)
    lda.fit(doc_term_matrix)
    
    # Extract top words for each topic
    feature_names = vectorizer.get_feature_names_out()
    topics = []
    
    for topic_idx, topic in enumerate(lda.components_):
        top_words_idx = topic.argsort()[-n_words:][::-1]
        top_words = [feature_names[i] for i in top_words_idx]
        topics.append({
            'topic_num': topic_idx + 1,
            'top_words': top_words
        })
    
    return pd.DataFrame(topics)

# Usage
topics_df = perform_topic_modeling(df_feedback['comment_clean'], n_topics=5)
print(topics_df)
```

## Visualization: The Synthesis Dashboard

```python
def create_synthesis_dashboard(funnel_data, theme_data, quotes):
    """
    Create a unified dashboard showing quant + qual insights
    """
    fig = plt.figure(figsize=(16, 10))
    gs = fig.add_gridspec(3, 2, hspace=0.3, wspace=0.3)
    
    # Top: Funnel (quantitative)
    ax1 = fig.add_subplot(gs[0, :])
    # ... funnel chart code from Day 10 ...
    
    # Middle Left: Theme breakdown (qualitative)
    ax2 = fig.add_subplot(gs[1, 0])
    # ... theme chart code ...
    
    # Middle Right: Sentiment by theme
    ax3 = fig.add_subplot(gs[1, 1])
    # ... sentiment chart code ...
    
    # Bottom: Quote callouts
    ax4 = fig.add_subplot(gs[2, :])
    ax4.axis('off')
    
    # Add representative quotes
    quote_text = "Representative User Voices:\n\n"
    for i, quote in enumerate(quotes[:3], 1):
        quote_text += f'{i}. "{quote}"\n\n'
    
    ax4.text(0.05, 0.95, quote_text, transform=ax4.transAxes,
            fontsize=10, verticalalignment='top', style='italic',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    plt.suptitle('The Discoverability Problem: Quantitative + Qualitative Evidence',
                fontsize=16, fontweight='bold')
    
    plt.savefig('synthesis_dashboard.png', dpi=300, bbox_inches='tight')
    return fig
```

## Best Practices for Qual-Quant Synthesis

### DO:
- ✅ Use qualitative to explain quantitative patterns
- ✅ Use quantitative to validate qual hypotheses at scale
- ✅ Include direct quotes (the user's voice matters)
- ✅ Look for contradictions (they reveal hidden complexity)
- ✅ Acknowledge limitations of both data sources

### DON'T:
- ❌ Cherry-pick quotes to fit your narrative
- ❌ Ignore quantitative evidence that contradicts qualitative
- ❌ Treat a few loud voices as representative
- ❌ Use qualitative as a replacement for statistical rigor
- ❌ Forget to quantify qualitative themes (counts matter)

## Deliverable Checklist

- [ ] `14_qualitative_analysis.ipynb` notebook created
- [ ] Feedback data loaded and cleaned
- [ ] Categorization function implemented
- [ ] Theme distribution calculated and visualized
- [ ] Representative quotes extracted for each theme
- [ ] Sentiment analysis performed (optional but recommended)
- [ ] Connection found between quantitative finding and qualitative themes
- [ ] Synthesis paragraph written with integrated narrative
- [ ] Supporting evidence (quotes + numbers) included
- [ ] Actionable insight derived from synthesis

## Key Takeaways

1. **Numbers without context are incomplete:** "60% drop-off" needs the "why" that only users can provide
2. **Quotes without scale are anecdotes:** Individual voices must be quantified to understand prevalence
3. **Look for explanations, not just confirmations:** Qualitative data is most powerful when it explains quantitative patterns
4. **Contradictions are insights:** When qual and quant disagree, dig deeper—there's a hidden variable
5. **The synthesis is the product:** Your job isn't to present two separate analyses; it's to weave them into one story

---

**Remember:** The best product analysts are translators. You translate numbers into stories and stories into numbers. You make data speak with the voice of real users, and you give user voices the weight of statistical evidence. This synthesis—this ability to move fluidly between the quantitative and qualitative—is what makes you indispensable to a product team.
