# Z.ai MCP Server Expansion Plan

## Current Status

**Implemented Tools:**
- ✅ `ask_glm5` - GLM-5 for general reasoning (text)
- ✅ `ask_glm5_pro` - GLM-5 for coding (text with coding system prompt)

**Current Limitations:**
- Only text-based LLM capabilities
- Missing: Image generation, OCR, audio transcription, vision, translation, presentation creation

## Recommended Expansions (Priority Order)

Based on GLM-5's analysis of GTM/sales/content workflows, here are the APIs to add:

---

### 🔴 HIGH PRIORITY (Add First)

#### 1. Web Search (LLM-Optimized Search Engine)

**Use Cases:**
- Competitive intelligence research (auto-search competitors)
- Market trend analysis for GTM strategy
- Real-time prospect research during `/prospect` workflow
- Content research for `/draft` and `/publish`
- Industry news monitoring for `/market-scan`

**Tool Name:** `web_search`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4/web_search`
- Engine: `search-prime` (Z.AI Premium Search Engine)
- Input: Search query string
- Params:
  - `count`: 1-50 results (default: 10, max: 50)
  - `search_domain_filter`: Whitelist specific domains
  - `search_recency_filter`: Time range (oneDay, oneWeek, oneMonth, oneYear, noLimit)
- Output: Array of results with:
  - Title, content summary, URL
  - Website name, favicon, publish date
  - Index number for referencing

**Why This is Critical:**
- LLM-optimized (not raw Google results)
- Returns structured summaries ready for analysis
- Time-filtered results (recent news/trends)
- Domain filtering (competitive analysis)
- Up to 50 results per search

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User asks for competitive research
- `/market-scan` needs industry trends
- `/prospect` requires company background
- Content research needed (>3 sources)
- Real-time information required

**Example Usage:**
```
User: /prospect Acme Corp

Sonnet: [Queries Airtable for existing data]
Sonnet: [Calls web_search: "Acme Corp company overview funding"]
Web Search: [Returns 10 LLM-optimized results]
Sonnet: [Calls web_search: "Acme Corp competitors market position"]
Web Search: [Returns competitive landscape]
Sonnet: [Synthesizes research, creates Airtable record]
Sonnet: [Calls Clay MCP for additional enrichment]
```

**Integration with Skills:**
- `/prospect` - Auto-research companies before creating deals
- `/market-scan` - Daily competitive intelligence gathering
- `/pre-call-prep` - Research prospects before meetings
- `/draft` - Source research for content creation
- `/content-plan` - Trend analysis for content strategy
- `/qualify` - Validate company fit via web research

**Cost:** Not specified in docs (likely per-search or included in plan)

---

#### 1b. Web Reader (Content Fetching & Parsing)

**Use Cases:**
- Read full articles/blog posts after web_search finds them
- Parse competitor product pages for detailed analysis
- Extract pricing information from competitor websites
- Read documentation pages for research
- Fetch case studies and whitepapers for content inspiration

**Tool Name:** `web_reader`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4/reader`
- Input: URL to fetch
- Params:
  - `return_format`: markdown (default) or text
  - `with_images_summary`: Include image summary (boolean)
  - `with_links_summary`: Include links summary (boolean)
  - `timeout`: Request timeout in seconds (default: 20)
- Output: Full page content in markdown format with:
  - Title, description
  - Main content (parsed, cleaned)
  - Metadata (keywords, viewport)

**Why This Complements web_search:**
- web_search finds URLs → web_reader fetches full content
- Perfect for deep analysis of specific pages
- Gets past paywalls and captures full text
- Markdown format ready for LLM processing

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User provides specific URL to analyze
- web_search returns interesting URLs to read in full
- Competitive page analysis needed (pricing, features)
- Content research requires full article text

**Example Workflow:**
```
User: Research competitor pricing for SaaS analytics tools

Sonnet:
1. Calls web_search: "SaaS analytics pricing 2026"
2. Gets 10 results with competitor URLs
3. Calls web_reader for top 5 competitor pricing pages
4. Extracts pricing tiers, features, positioning
5. Synthesizes competitive pricing analysis
6. Updates market-scan Airtable with findings
```

**Integration with web_search:**
```
/prospect Acme Corp

Sonnet:
1. web_search: "Acme Corp company overview"
2. web_reader: fetch Acme Corp website homepage
3. web_reader: fetch Acme Corp about/team page
4. web_search: "Acme Corp recent news" (oneWeek)
5. web_reader: read top 2 news articles in full
6. Synthesize comprehensive company profile
```

**Cost:** Not specified (likely per-request or included in plan)

---

#### 2. GLM-ASR-2512 (Audio Transcription)

**Use Cases:**
- Transcribe sales call recordings → CRM notes
- Convert voice memos into task items
- Process podcast/webinar recordings for content repurposing
- Meeting transcription for post-call analysis

**Tool Name:** `transcribe_audio`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4/audio/transcriptions`
- Input: Audio file (up to 25MB, ≤30 seconds) OR file URL
- Output: Text transcription
- Streaming: Supported (`stream=true`)
- Languages: Mandarin, English, French, German, Japanese, Korean, Spanish, Arabic, etc.
- Cost: Not specified (likely per-minute)

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User uploads audio file for transcription
- `/post-call` skill needs to process call recording
- Audio file is referenced in context

**Example Usage:**
```
User: Transcribe this sales call recording

Sonnet: [Calls transcribe_audio tool]
GLM-ASR: [Returns full transcript]
Sonnet: [Processes with /post-call skill to update Airtable]
```

---

#### 2. GLM-OCR (Document Parsing)

**Use Cases:**
- Extract text from PDF proposals, contracts, invoices
- Digitize business cards → CRM contacts
- Parse competitor marketing materials for analysis
- Convert scanned documents to editable text

**Tool Name:** `parse_document`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4` (layout parsing capability)
- Input: Image or PDF file
- Output: Structured text with layout information
- Speciality: Handles complex layouts, tables, multi-column text

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User uploads PDF/image for text extraction
- `/prospect` needs to analyze competitor materials
- Document analysis is required (>1 page)

**Example Usage:**
```
User: Extract the pricing from this competitor's PDF proposal

Sonnet: [Calls parse_document tool]
GLM-OCR: [Returns structured text]
Sonnet: [Analyzes pricing, updates market-scan data]
```

---

#### 3. GLM Slide/Poster Agent (Presentation Creation)

**Use Cases:**
- Generate pitch decks from outline/notes
- Create QBR presentations automatically
- Design case study slides
- Build product launch decks

**Tool Name:** `create_presentation`

**API Details:**
- Endpoint: Agent-based (likely chat completion with special agent)
- Input: Text prompt describing presentation needs
- Output: Generated slide deck (PPT/PDF format)
- Speciality: "One-click professional material generation"

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User requests deck/presentation creation
- `/deck` skill is invoked
- Multi-slide content generation needed

**Example Usage:**
```
User: /deck for Q1 product launch

Sonnet: [Gathers product info from Airtable]
Sonnet: [Calls create_presentation with product data]
GLM Slide Agent: [Returns 15-slide deck]
Sonnet: [Saves to files, offers refinements]
```

---

### 🟡 MEDIUM PRIORITY (Add Second Wave)

#### 4. GLM-Image (Image Generation)

**Use Cases:**
- Generate social media visuals for campaigns
- Create blog header images
- Design ad creatives quickly
- Produce custom illustrations for case studies

**Tool Name:** `generate_image`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4/images/generations`
- Input: Text prompt describing image
- Params: Size (1280×1280, 1568×1056, custom 512-2048px)
- Output: Image URL (user downloads)
- Cost: $0.015 per image

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User requests image creation from text
- `/publish` needs visual assets
- Social media content requires graphics

**Example Usage:**
```
User: Create a hero image for our AI automation blog post

Sonnet: [Calls generate_image with blog theme]
GLM-Image: [Returns image URL]
Sonnet: [Downloads, saves to content folder, updates publish tracker]
```

---

#### 5. GLM-4.6V (Vision/Multimodal)

**Use Cases:**
- Analyze competitor website screenshots
- Review marketing asset designs (QA)
- Extract insights from charts/graphs
- Brand monitoring (logo/visual compliance)

**Tool Name:** `analyze_image`

**API Details:**
- Endpoint: `https://api.z.ai/api/paas/v4/chat/completions`
- Model: `glm-4.6v`
- Input: Image URL or base64 + text prompt
- Output: Text analysis/description

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User uploads image for analysis
- Screenshot analysis is needed
- Visual QA is required (>200 words analysis)

**Example Usage:**
```
User: Analyze this competitor landing page screenshot

Sonnet: [Calls analyze_image]
GLM-4.6V: [Analyzes layout, messaging, CTA placement]
Sonnet: [Summarizes competitive insights, updates market-scan]
```

---

#### 6. Translation Agent (Multilingual Translation)

**Use Cases:**
- Localize marketing collateral for international markets
- Translate sales decks for global prospects
- Convert content for multilingual campaigns
- Support international customer communications

**Tool Name:** `translate_content`

**API Details:**
- Endpoint: Agent-based translation service
- Input: Text + source/target language
- Output: Translated text with glossary support
- Speciality: Maintains brand voice, handles domain terminology

**Delegation Threshold:**
Sonnet should auto-delegate when:
- User requests translation (>500 words)
- `/repurpose` needs multi-language versions
- International campaign content is needed

**Example Usage:**
```
User: /repurpose this case study for French and German markets

Sonnet: [Calls translate_content for each language]
Translation Agent: [Returns FR and DE versions]
Sonnet: [Saves to content library, updates Airtable]
```

---

### 🟢 LOW PRIORITY (Future Expansion)

#### 7. CogVideoX-3 (Video Generation)

**Use Cases:**
- Create short product demo videos
- Generate video versions of blog posts
- Produce explainer videos from scripts
- Social media video content

**Why Low Priority:**
- Video generation is expensive
- GTM/sales work is mostly text/image-focused
- Complex output requires significant post-processing
- User likely has existing video production workflows

**Tool Name:** `generate_video` (if implemented later)

---

## Implementation Roadmap

### Phase 1: Core Expansion (High Priority)
**Timeline:** Week 1-2

1. ✅ **IMPLEMENTED** `web_search` (Web Search API) - Search engine
2. ✅ **IMPLEMENTED** `web_reader` (Web Reader API) - Fetch & parse URLs
3. ⏳ Add `transcribe_audio` (GLM-ASR-2512)
4. ⏳ Add `parse_document` (GLM-OCR)
5. ⏳ Add `create_presentation` (Slide Agent)

**Expected Impact:**
- Automated competitive/market research → 15+ hours/week saved
- Auto-transcribe sales calls → 10+ hours/week saved
- Digitize inbound leads from PDFs → 50% faster qualification
- Generate decks automatically → 5+ hours/week saved
- **Total time saved: 30+ hours/week**

### Phase 2: Content Enhancement (Medium Priority)
**Timeline:** Week 3-4

4. ✅ Add `generate_image` (GLM-Image)
5. ✅ Add `analyze_image` (GLM-4.6V)
6. ✅ Add `translate_content` (Translation Agent)

**Expected Impact:**
- Produce social media visuals → 3x content output
- Competitive analysis from screenshots → faster market insights
- Multilingual campaigns → expand TAM by 40%

### Phase 3: Video (Future)
**Timeline:** TBD (based on demand)

7. ⏸️ Add `generate_video` (if needed)

---

## Project Instructions Update

Once new tools are added, update project instructions to include:

```markdown
## Auto-Delegate to Z.ai MCP Tools

### Web Search (web_search)
- Competitive research (>3 companies)
- Market trend analysis
- Company background research
- Content source research (>3 sources)
- Real-time news/information needs
- Industry intelligence gathering

### Audio Processing (transcribe_audio)
- Sales call transcription (>1 min)
- Voice memo processing
- Meeting recordings
- Podcast/webinar transcription

### Document Processing (parse_document)
- PDF text extraction (>1 page)
- Business card digitization
- Contract/invoice parsing
- Competitor material analysis

### Presentation Creation (create_presentation)
- Deck generation (>5 slides)
- Pitch deck creation
- QBR presentations
- Product launch decks

### Image Generation (generate_image)
- Social media graphics
- Blog headers
- Ad creative mockups
- Custom illustrations

### Image Analysis (analyze_image)
- Screenshot analysis (>200 words)
- Visual QA review
- Competitor website analysis
- Brand monitoring

### Translation (translate_content)
- Content localization (>500 words)
- Multi-language campaigns
- International collateral
```

---

## Cost Analysis

### Current Costs (GLM-5 only):
- Text generation: ~$1-3 per 1M input tokens
- Estimated: $40-60/month for typical usage

### Projected Costs (All Tools):
- GLM-5 (text): $40-60/month
- GLM-ASR (audio): ~$10-20/month (based on call volume)
- GLM-OCR (documents): ~$5-10/month
- GLM-Image (images): ~$10-15/month (@$0.015/image × 700 images)
- GLM-4.6V (vision): ~$5-10/month
- Translation Agent: ~$10-15/month
- Slide Agent: ~$5-10/month

**Total Estimated:** $85-140/month

**ROI Calculation:**
- Time saved: ~25 hours/month
- Value of time: ~$100/hour (sales/GTM role)
- Total value: $2,500/month
- **ROI: 18x-30x**

---

## Success Metrics

### Phase 1 Success Criteria:
- ✅ 80%+ of sales calls auto-transcribed
- ✅ 50%+ of inbound PDFs auto-parsed
- ✅ 3+ decks generated per week via automation

### Phase 2 Success Criteria:
- ✅ 90%+ social posts include auto-generated visuals
- ✅ Competitive screenshots analyzed within 24 hours
- ✅ 2+ languages supported for every campaign

---

## Next Steps

1. **Review this plan** and prioritize which tools to implement first
2. **Confirm API access** - verify Z.ai Pro plan includes all these APIs
3. **Update MCP server** - add tools one at a time
4. **Test each tool** - verify integration works before moving to next
5. **Update project instructions** - add delegation rules for new tools
6. **Monitor usage & costs** - track ROI for each capability

---

## Technical Implementation Notes

### File Structure:
```
/Users/poornamac/Documents/MCP/glm5-mcp/
├── index.js (main server - add new tools here)
├── package.json (update if new dependencies needed)
├── EXPANSION_PLAN.md (this file)
├── SETUP_COMPLETE.md (original setup docs)
└── FIXES_APPLIED.md (troubleshooting history)
```

### Adding a New Tool (Template):

```javascript
{
  name: "tool_name",
  description: "Use this for: [use cases]. Delegate when [conditions].",
  inputSchema: {
    type: "object",
    properties: {
      // Define parameters
    },
    required: ["param1"]
  }
}
```

### API Call Pattern:

```javascript
const response = await fetch(`${API_BASE}/endpoint`, {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${API_KEY}`,
  },
  body: JSON.stringify({
    model: "model-name",
    // ... parameters
  }),
});
```

---

## Resources

- [Z.ai API Documentation](https://docs.z.ai/)
- [GLM-Image Guide](https://docs.z.ai/guides/image/glm-image)
- [GLM-ASR Guide](https://docs.z.ai/guides/audio/glm-asr-2512)
- [Z.ai API Reference](https://docs.z.ai/api-reference/introduction)
- [Z.ai GitHub Examples](https://github.com/CloudAI-X/z-ai-playground-v2)
