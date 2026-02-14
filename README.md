# GLM-5 MCP Server for Claude Desktop

**Reduce Claude Desktop consumption by 10x** by delegating heavy tasks to Z.ai's GLM-5 (744B parameter) model through the Model Context Protocol (MCP).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-blue.svg)](https://modelcontextprotocol.io)
[![GitHub stars](https://img.shields.io/github/stars/Arkya-AI/glm5-mcp?style=social)](https://github.com/Arkya-AI/glm5-mcp)
[![GitHub release](https://img.shields.io/github/v/release/Arkya-AI/glm5-mcp)](https://github.com/Arkya-AI/glm5-mcp/releases)

## 🎯 Problem This Solves

**Are you hitting Claude Pro limits too fast?**

- Weekly limit exhausted in 2 days? ✅
- Blocked from all models for days? ✅
- Paying $100/month but can't use it 5 days/week? ✅

**This MCP server gives you:**
- **10x reduction** in Claude consumption (Opus 4.6 → Sonnet 4.5 + GLM-5 delegation)
- **5x reduction** in Claude consumption (Opus 4.6 → Opus 4.6 + GLM-5 delegation)
- **Continuous availability** - never blocked again
- **Cost-effective scaling** - $40-60/month Z.ai vs. $100 to 200$ /month paid additional to claude to continue using
- **18-30x ROI** on your Claude Pro subscription

## 🚀 Quick Start

### 1. Get Z.ai API Key

1. Visit [Z.ai](https://z.ai) and create an account
2. Navigate to [API Keys](https://z.ai/manage-apikey/apikey-list)
3. Create a new API key
4. Copy your key (format: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx`)

### 2. Install

```bash
# Clone the repository
git clone https://github.com/Arkya-AI/glm5-mcp.git
cd glm5-mcp

# Install dependencies
npm install
```

### 3. Configure Claude Desktop

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

```json
{
  "mcpServers": {
    "glm5": {
      "command": "node",
      "args": [
        "/ABSOLUTE/PATH/TO/glm5-mcp/index.js"
      ],
      "env": {
        "ZAI_API_KEY": "your-z-ai-api-key-here"
      }
    }
  }
}
```

**Important:** Replace `/ABSOLUTE/PATH/TO/` with the actual path to where you cloned the repo.

### 4. Restart Claude Desktop

Quit Claude Desktop completely and restart it. The GLM-5 tools will now be available.

## 🛠️ Available Tools

### Core AI Tools

#### `ask_glm5`
Delegate complex reasoning tasks to GLM-5 (744B parameters).

**Use for:**
- Complex analysis and reasoning
- System design and architecture
- Advanced problem-solving
- Multi-step logical tasks

**Parameters:**
- `prompt` (required): Your task/question
- `system_prompt` (optional): Custom behavior guidance
- `temperature` (optional): 0.0-1.0, default 0.7
- `max_tokens` (optional): Max response length, default 4000

#### `ask_glm5_pro`
Same as `ask_glm5` but with coding-optimized system prompt.

**Use for:**
- Code generation
- Refactoring and optimization
- Debugging assistance
- Technical implementation

### Research & Intelligence Tools

#### `web_search`
LLM-optimized web search powered by Z.ai.

**Use for:**
- Competitive intelligence
- Market research
- Real-time news and trends
- Finding multiple sources

**Parameters:**
- `search_query` (required): Your search query
- `count` (optional): Results 1-50, default 10
- `search_recency_filter` (optional): oneDay, oneWeek, oneMonth, oneYear, noLimit
- `search_domain_filter` (optional): Comma-separated domains

#### `web_reader`
Fetch and parse full web page content.

**Use for:**
- Reading articles and blog posts
- Analyzing competitor pages
- Extracting documentation
- Deep content analysis

**Parameters:**
- `url` (required): URL to fetch
- `return_format` (optional): markdown or text, default markdown
- `with_images_summary` (optional): Include image summary, default false
- `with_links_summary` (optional): Include links summary, default false
- `timeout` (optional): Timeout in seconds, default 20

#### `parse_document`
Extract text from PDFs and images using GLM-OCR.

**Use for:**
- PDF proposals and contracts
- Scanned documents
- Business cards
- Invoices and receipts
- Complex layouts and tables

**Parameters:**
- `file_url` (required): Public URL to document/image
- `return_format` (optional): markdown or text, default markdown
- `parse_mode` (optional): auto, ocr, or layout, default auto

**Supports:** PDF, images up to 50MB or 100 pages

## 📊 Usage Strategy

### Hybrid Approach (Recommended)

**Use Claude Sonnet 4.5** as your default model for:
- Orchestration and planning
- File operations and code editing
- Tool coordination
- Quick responses

**Delegate to GLM-5** for:
- Complex analysis (>500 words output)
- Deep technical problems
- Research synthesis
- Code generation (>100 lines)

**Example workflow:**
1. Start session with Sonnet 4.5
2. Use `web_search` to find sources
3. Use `web_reader` to fetch content
4. Use `ask_glm5` to analyze and synthesize
5. Sonnet formats and presents results

### Expected Savings

**Before GLM-5 MCP:**
- Weekly limit in 2 days
- 5 days blocked per week
- $100/month for 28% availability

**After GLM-5 MCP:**
- Sonnet 4.5: 10x less quota usage
- GLM-5: Handle heavy lifting
- 100% continuous availability
- $140-160/month total cost

**ROI: 18-30x improvement in effective cost per hour of usage**

## 🔧 Development

### Project Structure

```
glm5-mcp/
├── index.js           # Main MCP server
├── package.json       # Dependencies
├── README.md          # This file
├── LICENSE            # MIT License
└── .gitignore         # Git ignore rules
```

### Testing

```bash
# Test the MCP server
npm start
```

The server will start in stdio mode and log to stderr. Use Claude Desktop to test the tools.

### Adding New Tools

1. Add tool definition to `ListToolsRequestSchema` handler
2. Add tool handler in `CallToolRequestSchema` handler
3. Update README documentation
4. Test in Claude Desktop

## 📖 Documentation

### For Users
- **[README.md](README.md)** - Setup and installation guide (you're here!)
- **[EXAMPLES.md](EXAMPLES.md)** - Real-world usage examples
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute

### For Claude
- **[CLAUDE.md](CLAUDE.md)** - **Comprehensive project memory and delegation guidelines**
  - When to use each tool (Sonnet 4.5 vs Opus 4.6 strategies)
  - Code quality standards and patterns
  - Optimization rules to reduce Claude consumption
  - Development workflow and troubleshooting

### API Reference
This MCP server uses the [Z.ai API](https://docs.z.ai). Key endpoints:

- `/paas/v4/chat/completions` - GLM-5 text generation
- `/paas/v4/web_search` - Web search
- `/paas/v4/reader` - Web content fetching

See [Z.ai Documentation](https://docs.z.ai) for complete API reference.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

1. Follow existing code style
2. Add tests for new features
3. Update documentation
4. Keep tools focused and single-purpose

### Ideas for Contributions

- Add translation agent support
- Add slide generation (GLM Slide Agent)
- Add streaming support for real-time responses
- Add error retry logic
- Add caching for repeated queries
- Add usage tracking and analytics

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) for Claude and MCP
- [Z.ai](https://z.ai) for GLM-5 API access
- MCP community for the protocol specification

## 🔗 Links

- [Model Context Protocol](https://modelcontextprotocol.io)
- [Z.ai Documentation](https://docs.z.ai)
- [Claude Desktop](https://claude.ai/download)
- [Issue Tracker](https://github.com/Arkya-AI/glm5-mcp/issues)
- [Discussions](https://github.com/Arkya-AI/glm5-mcp/discussions)

## 💡 Use Cases

### Competitive Intelligence
```
1. web_search("competitor X new features 2024")
2. web_reader(top_results)
3. ask_glm5("Analyze competitor strategy and our response")
```

### Research Synthesis
```
1. web_search("market trends AI agents", count=50)
2. Multiple web_reader() calls
3. ask_glm5("Synthesize findings into executive summary")
```

### Document Analysis
```
1. parse_document("https://example.com/contract.pdf")
2. ask_glm5("Extract key terms, risks, and obligations")
```

### Code Generation
```
1. ask_glm5_pro("Build a React component for user authentication with OAuth")
2. Sonnet integrates into codebase
```

## 🆘 Troubleshooting

### Tools not appearing in Claude Desktop

1. Check config file path is correct
2. Verify absolute path to `index.js`
3. Restart Claude Desktop completely (quit, don't just close window)
4. Check Claude Desktop logs for errors

### API errors

1. Verify Z.ai API key is valid
2. Check API key has sufficient credits
3. Ensure network connectivity
4. Check Z.ai service status

### Empty responses

1. GLM-5 may be rate-limited
2. Try lowering `max_tokens`
3. Check error logs in terminal
4. Verify prompt is clear and specific

## 📈 Roadmap

- [ ] Add translation agent (40+ languages)
- [ ] Add slide generation
- [ ] Add image generation
- [ ] Add audio transcription
- [ ] Add streaming support
- [ ] Add response caching
- [ ] Add usage analytics
- [ ] Add configuration UI
- [ ] Add preset prompt templates

---

**Made with ❤️ to help Claude users do more without limits**
