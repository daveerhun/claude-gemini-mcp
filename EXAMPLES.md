# GLM-5 MCP Usage Examples

Real-world examples of how to use GLM-5 MCP tools to reduce Claude consumption and extend your capabilities.

## 🎯 Quick Reference

| Task | Tools Used | Time Saved |
|------|------------|------------|
| Competitive Analysis | web_search → web_reader → ask_glm5 | 15-30 min |
| Document Analysis | parse_document → ask_glm5 | 10-15 min |
| Research Synthesis | web_search → ask_glm5 | 20-40 min |
| Code Generation | ask_glm5_pro | 5-10 min |

---

## Example 1: Competitive Intelligence

**Goal:** Analyze a competitor's new product launch

**Conversation with Claude:**

```
You: "Research competitor X's new AI product launched this month"

Claude: Let me search for recent information about this.
[Uses web_search with oneMonth filter]

Claude: I found 12 relevant articles. Let me read the key ones.
[Uses web_reader on top 3 results]

Claude: Now I'll analyze their strategy and positioning.
[Uses ask_glm5 with synthesis prompt]

Claude: Here's my analysis...
```

**Behind the scenes:**
1. `web_search` finds recent announcements
2. `web_reader` extracts full article content
3. `ask_glm5` performs deep analysis
4. Claude (Sonnet) orchestrates and presents

**Claude consumption:** ~500 tokens (orchestration only)
**GLM-5 consumption:** ~2000 tokens (heavy analysis)

---

## Example 2: PDF Contract Review

**Goal:** Extract key terms from a legal contract

**Conversation:**

```
You: "Review this contract and list key obligations, risks, and dates"
     [Provides PDF URL]

Claude: I'll parse the document first.
[Uses parse_document]

Claude: Now analyzing the extracted content...
[Uses ask_glm5 with legal analysis prompt]

Claude: Here are the key findings:
- Obligations: [list]
- Risks: [list]
- Important dates: [list]
```

**Tools used:**
1. `parse_document("https://example.com/contract.pdf")`
2. `ask_glm5("Analyze this contract...")`

**Why this works:**
- GLM-OCR handles complex PDF layouts
- GLM-5 does the heavy legal analysis
- Claude presents structured findings

---

## Example 3: Market Research Report

**Goal:** Create an executive summary of AI agent market trends

**Conversation:**

```
You: "Create a market analysis report on AI agents - trends, key players,
      market size, growth projections"

Claude: I'll search for comprehensive market data.
[Uses web_search with count=50]

Claude: Reading detailed reports from Gartner, McKinsey, and industry sites.
[Uses web_reader on 10 key sources]

Claude: Synthesizing findings into executive summary...
[Uses ask_glm5 with 5000+ word synthesis]

Claude: Here's your report:
# AI Agent Market Analysis 2024
[Comprehensive report with data, trends, projections]
```

**Claude consumption:** ~1000 tokens
**GLM-5 consumption:** ~5000 tokens
**Savings:** 80% reduction vs. Claude doing everything

---

## Example 4: Code Generation

**Goal:** Build a React authentication component

**Conversation:**

```
You: "Build a React component for OAuth authentication with Google and GitHub"

Claude: I'll generate the implementation.
[Uses ask_glm5_pro with detailed spec]

Claude: Here's the component:
[Integrates GLM-5's code into project]

Claude: I've added it to your auth/ directory. Would you like me to add tests?
```

**Tools used:**
1. `ask_glm5_pro("Create a React OAuth component...")`
2. Claude (Sonnet) integrates and tests

**Why delegate to GLM-5:**
- Code generation is token-heavy
- GLM-5 Pro optimized for coding
- Claude handles file operations

---

## Example 5: Multi-Source Research

**Goal:** Compare pricing strategies across competitors

**Conversation:**

```
You: "Compare pricing models of Anthropic, OpenAI, and Google for LLM APIs"

Claude: Searching for current pricing pages...
[Uses web_search for each company + "pricing api"]

Claude: Fetching pricing details...
[Uses web_reader on 3 pricing pages]

Claude: Analyzing pricing strategies and competitive positioning...
[Uses ask_glm5 with competitive analysis prompt]

Claude: Here's the comparison:
[Table with pricing, features, positioning analysis]
```

**Workflow:**
1. `web_search("Anthropic API pricing 2024")`
2. `web_search("OpenAI API pricing 2024")`
3. `web_search("Google Gemini API pricing 2024")`
4. `web_reader(url)` for each result
5. `ask_glm5("Compare these pricing strategies...")`

---

## Example 6: Document Translation + Analysis

**Goal:** Analyze a competitor's Japanese product docs

**Conversation:**

```
You: "Analyze this Japanese product documentation"
     [Provides URL to Japanese PDF]

Claude: First, I'll extract the text.
[Uses parse_document]

Claude: The document is in Japanese. I'll analyze it directly.
[Uses ask_glm5 with multilingual analysis]

Claude: Here's what I found:
- Key features: [list]
- Technical architecture: [description]
- Competitive advantages: [analysis]
```

**Note:** GLM-5 has multilingual capabilities, so you can analyze content in various languages without explicit translation.

---

## Example 7: Data Synthesis from Multiple PDFs

**Goal:** Compare features across 3 competitor whitepapers

**Conversation:**

```
You: "Compare technical approaches in these 3 whitepapers"
     [Provides 3 PDF URLs]

Claude: Parsing all three documents...
[Uses parse_document 3 times in parallel]

Claude: Analyzing and comparing approaches...
[Uses ask_glm5 with comparison framework]

Claude: Here's the feature comparison matrix:
[Detailed comparison table]
```

**Advanced tip:** Claude can coordinate multiple tool calls in parallel for efficiency.

---

## Example 8: Ongoing Research Assistant

**Goal:** Daily competitive monitoring

**Conversation:**

```
You: "Check for any news about competitor X from the past day"

Claude: Searching recent news...
[Uses web_search with search_recency_filter: "oneDay"]

Claude: Found 2 announcements. Reading details...
[Uses web_reader]

Claude: Here's what's new:
1. [Summary of announcement 1]
2. [Summary of announcement 2]

Would you like me to analyze the implications?
```

**Automation potential:** You could run this daily to stay updated.

---

## 💡 Best Practices

### When to Delegate to GLM-5

**Always delegate:**
- Analysis >500 words
- Code generation >100 lines
- Multi-document synthesis
- Complex reasoning chains
- Deep technical explanations

**Keep in Claude (Sonnet):**
- File operations
- Quick Q&A
- Tool coordination
- Response formatting
- Context maintenance

### Prompt Engineering for GLM-5

**Good prompts:**
```javascript
ask_glm5({
  prompt: "Analyze the competitive positioning of Product X vs Y. Focus on: 1) Target market, 2) Pricing strategy, 3) Technical differentiation, 4) Go-to-market approach. Use the following data: [data]",
  temperature: 0.3 // Lower for analytical tasks
})
```

**Less effective:**
```javascript
ask_glm5({
  prompt: "Compare products", // Too vague
  temperature: 1.0 // Too random for analysis
})
```

### Chaining Tools Effectively

**Efficient workflow:**
1. Sonnet plans the research strategy
2. `web_search` finds sources
3. `web_reader` extracts content (parallel if possible)
4. `ask_glm5` synthesizes findings
5. Sonnet formats and presents

**Inefficient workflow:**
1. Claude searches and reads everything (high token usage)
2. Claude does analysis (even higher usage)
3. Hit rate limits quickly

---

## 📊 ROI Calculator

**Traditional approach (Claude Opus 4.6 only):**
- Competitive analysis: ~8000 tokens
- Document review: ~6000 tokens
- Research synthesis: ~12000 tokens
- **Total:** 26000 tokens
- **Claude Pro limit:** ~100,000 tokens/week
- **Days to limit:** ~2 days

**Hybrid approach (Sonnet + GLM-5):**
- Claude orchestration: ~3000 tokens total
- GLM-5 analysis: ~20000 tokens (Z.ai credits)
- **Claude consumption:** 3000 tokens
- **Days to limit:** 20+ days

**Savings:** 10x more work from same Claude Pro subscription

---

## 🚀 Advanced Patterns

### Pattern 1: Recursive Research
```
1. web_search (broad query)
2. ask_glm5 ("identify knowledge gaps")
3. web_search (targeted queries based on gaps)
4. web_reader (deep dive on specific sources)
5. ask_glm5 (final synthesis)
```

### Pattern 2: Comparative Analysis Pipeline
```
For each competitor:
  1. web_search (company + topic)
  2. web_reader (top 3 results)
  3. Store findings

ask_glm5 (synthesize all findings into comparison)
```

### Pattern 3: Document Processing Workflow
```
1. parse_document (extract text)
2. ask_glm5 (identify key sections)
3. ask_glm5_pro (generate summary code/structure)
4. Sonnet (integrate into project)
```

---

## 🎓 Learning Resources

- [MCP Best Practices](https://modelcontextprotocol.io/docs)
- [Z.ai Model Guide](https://docs.z.ai)
- [Prompt Engineering Guide](https://www.promptingguide.ai)

---

**Have a great example?** Submit a PR to add it here!
