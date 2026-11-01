# InfraMap MCP server

The InfraMap MCP server gives AI assistants read-only access to InfraMap Pro's US power market data: every operating US power plant with its generation, emissions, ownership and offtake, plus ISO node prices, hub prices and basis in seven markets. It has 43 tools, and every result carries its sources, period and coverage.

- **Server URL:** `https://mcp.inframap.pro/mcp` (Streamable HTTP)
- **Sign-in:** OAuth. Your client opens the InfraMap sign-in page the first time it connects.
- **Account:** an [InfraMap Pro](https://www.inframap.pro?utm_source=github&utm_medium=readme), Team or Enterprise plan. See [pricing](https://www.inframap.pro/pricing?utm_source=github&utm_medium=readme).
- **Listed in:** [Claude's connectors directory](https://claude.ai/directory/connectors/inframap)
- **Setup for 18 clients:** [mcp.inframap.pro](https://mcp.inframap.pro?utm_source=github&utm_medium=readme) and [the docs](https://www.inframap.pro/docs/mcp?utm_source=github&utm_medium=readme)

The server is hosted by InfraMap. This repository holds its documentation, client configuration, registry entry and a Claude Code plugin; the server's source code is not published here.

## What you can ask

- Show Barry's reported monthly generation for 2024, including any missing months and the source for each value.
- How many plants in each ISO have a reviewed market price node, and how many have none?
- Which wind and solar plants had the largest increase in modeled curtailment from 2024 to 2025? Show both the credit and no-credit bounds.
- Estimate Moccasin's wholesale energy revenue for January through June 2025 and say which price node you used.
- Which coal plants reported the most cooling water withdrawal, and what is the water stress at each site?

More in [examples/prompts.md](examples/prompts.md).

## Connect

### Claude (web, desktop and mobile)

Open [InfraMap in the connectors directory](https://claude.ai/directory/connectors/inframap) and choose Connect. Claude opens the InfraMap sign-in page.

If the directory isn't available to you, go to Customize, Connectors, choose Add custom connector, name it InfraMap and paste `https://mcp.inframap.pro/mcp`.

### Claude Code

```bash
claude mcp add --transport http --scope user inframap https://mcp.inframap.pro/mcp
```

Then run `/mcp` in Claude Code, pick inframap and choose Authenticate. To install the server together with the InfraMap research skill, use the plugin in this repository:

```text
/plugin marketplace add inframaporg/mcp
/plugin install inframap@inframap
```

### ChatGPT

Go to chatgpt.com/plugins, choose +, then Add custom MCP server. Name it InfraMap, paste `https://mcp.inframap.pro/mcp`, set Authentication to OAuth and choose Create as a plugin. In a chat, type @ and pick InfraMap.

### Codex

```bash
codex mcp add inframap --url https://mcp.inframap.pro/mcp
codex mcp login inframap
```

### Cursor

Add to `~/.cursor/mcp.json` (everywhere) or `.cursor/mcp.json` (one project):

```json
{
  "mcpServers": {
    "inframap": {
      "url": "https://mcp.inframap.pro/mcp"
    }
  }
}
```

Cursor then shows a sign-in prompt for inframap under Customize, MCPs.

### VS Code

```bash
code --add-mcp '{"name":"inframap","type":"http","url":"https://mcp.inframap.pro/mcp"}'
```

Or add `.vscode/mcp.json` to a project:

```json
{
  "servers": {
    "inframap": {
      "type": "http",
      "url": "https://mcp.inframap.pro/mcp"
    }
  }
}
```

### Gemini CLI

```bash
gemini mcp add --transport http --scope user inframap https://mcp.inframap.pro/mcp
```

### Any other client

Most clients accept a remote server as a name and a URL. Use Streamable HTTP; the server has no SSE endpoint. For clients that only start local servers, the open-source [mcp-remote](https://www.npmjs.com/package/mcp-remote) bridge forwards to InfraMap and handles sign-in:

```json
{
  "mcpServers": {
    "inframap": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://mcp.inframap.pro/mcp"
      ]
    }
  }
}
```

Config files for each client are in [examples/](examples/).

## Tools

All 43 tools are read-only. Start with `get_data_catalog` to see what each dataset covers and how current it is.

### Analyst store

Whole-inventory screens in SQL, one-call project dossiers and reviewed definitions.

| Tool | What it does |
| --- | --- |
| `query_analyst_store` | **Query the analyst store (SQL).** Run one read-only SQLite SELECT over the analyst store to screen, rank, count or compare projects across the whole inventory. Returns up to 200 rows with the store version and table citations. |
| `get_project_profile` | **Get project profile.** Dossier for up to 5 projects: identity, capacity, region, pricing node and hub, earlier nodes from price chains, recent generation and capacity factor, ownership, offtake and 2024–2025 price and basis. |
| `get_energy_reference` | **Look up energy definitions.** Reviewed definitions, formulas, guards and primary references for energy terms and study topics such as capacity factor, basis, capture rate, ELCC and curtailment. |

### Discovery and definitions

What data exists, how current it is, and which tool reads it.

| Tool | What it does |
| --- | --- |
| `get_data_catalog` | **Inspect the data catalog.** Every approved data source with its as-of date, coverage, tools and limits. Call it first. |
| `discover_energy_data` | **Find datasets.** Search datasets by research terms, or inspect one dataset ID for meaning, grain, join rules and coverage. |
| `get_source_catalog` | **List loaded source datasets.** Loaded source tables (water, boiler fuel, utilities, gas operators, EQR contracts, modeled renewable profiles) with grain, fields and caveats. |
| `get_analysis_guide` | **Get analysis guide.** Reviewed terminology, formulas, study checklists and primary references for study design. |
| `explain_analysis_limit` | **Explain an analysis limit.** Explains a known gap, the inputs it would need and the closest supported alternative. |

### Projects and regions

Find plants, resolve grid areas and read source-level project evidence.

| Tool | What it does |
| --- | --- |
| `search_energy_projects` | **Search power plants.** Filter, rank and page the current operating EIA catalog by state, fuel, ISO, balancing authority, county, size and hybrid status. Hybrid components are grouped once. |
| `get_project_details` | **Get generator and plant details.** Generator and plant fields for exact EIA plant IDs, with generator paging. |
| `get_project_evidence_bundle` | **Get project evidence bundle.** Compact verified evidence and yearly summaries for up to 5 projects and 60 months, by section. |
| `resolve_grid_areas` | **Resolve grid areas.** Resolve an ISO, RTO or balancing-authority code, name or alias before filtering plants. |
| `get_project_grid_membership` | **Get project grid membership.** Dated unit-level balancing-authority relationships for one project, including reviewed transitions. |
| `get_project_source_coverage` | **Get project source coverage.** Which source datasets hold records for a project, with the native IDs to query them. |
| `get_grid_topology` | **Get grid network coverage.** Public OpenStreetMap network coverage and per-project USGS and OSM geometry counts. |

### Generation, emissions, ownership

Reported output, performance, potential, emissions and ownership.

| Tool | What it does |
| --- | --- |
| `get_project_generation` | **Get project generation.** EIA-923 monthly net MWh, with battery charging and discharging kept separate. |
| `get_project_performance` | **Get project performance.** Complete-period generation, dated nameplate capacity factor, battery flows and utilization for up to 5 projects. |
| `get_project_generation_potential` | **Compare generation with modeled potential.** Actual generation beside reviewed physical potential and retrospective expected generation. |
| `get_project_emissions` | **Get project emissions.** Annual EPA CO₂, SO₂ and NOx mass for monitored units, linked through the PUDL CAMD–EIA crosswalk. US short tons. |
| `get_project_ownership` | **Get project ownership.** Dated ownership and offtake conclusions and reported generator relationships. |
| `rank_generation_change` | **Rank generation change.** Rank reported net generation change between the same months of two years across the filtered fleet. |
| `rank_capacity_factors` | **Rank wind capacity factors.** Pick the largest wind projects by operating wind nameplate, then rank their capacity factors. |

### Markets

Live 5-minute prices, node and hub prices, basis, period analysis and modeled revenue in seven ISOs and RTOs.

| Tool | What it does |
| --- | --- |
| `get_eqr_hourly_sales` | **Get FERC EQR hourly sales.** Seller-reported hourly sales by delivery point for about 430 plants in 2026 Q2. Reported sales, not metered generation. |
| `get_live_prices` | **Get live 5-minute prices.** The newest 5-minute real-time prices at every hub and zone, or up to 8 days at one hub or 2 days at a plant's pricing node, or hourly real-time and day-ahead prices for up to 62 days from the archive, with congestion and loss components and day-ahead against real-time. Updated every 5 minutes in all seven markets. |
| `get_project_market_prices` | **Get project market prices.** Node coverage or one month of price statistics for a plant outside ERCOT (CAISO, ISO-NE, MISO, NYISO, PJM, SPP). |
| `get_ercot_project_data` | **Get ERCOT project data.** ERCOT resource net energy (SMNE), node and hub settlement point prices and basis for one month. |
| `analyze_market_period` | **Analyze a market period.** Prices, basis and coverage for up to 5 projects over up to 12 months in any of the seven markets. |
| `model_project_revenue` | **Model project energy revenue.** Historical modeled energy revenue: monthly EIA net generation times the same month’s mean node price. |
| `rank_ercot_basis` | **Rank ERCOT basis.** Rank reviewed ERCOT projects by node minus hub price for one month, hub and market. |
| `assess_capture_rate_coverage` | **Check capture rate coverage.** Checks whether exact capture rates can be computed for a project, and what is missing. |

### Curtailment

The experimental modeled curtailment range, and operator-published regional history.

| Tool | What it does |
| --- | --- |
| `compare_project_curtailment` | **Compare modeled curtailment.** Screen or compare modeled curtailment across the full eligible cohort between matched month windows, nationally or by ISO, state or technology. |
| `investigate_project_curtailment` | **Investigate modeled curtailment.** Hour-level investigation for up to 5 plants over at most 366 days: loss blocks, durations, price coincidence and seasonality. |
| `get_project_modeled_curtailment` | **Get modeled curtailment.** Monthly modeled curtailed MWh, expected curtailed hours and physical potential for one plant and year. |
| `get_regional_curtailment_history` | **Get operator curtailment history.** Operator-published regional curtailment: CAISO 2015–2025 and SPP 2024–2025. |

### ERCOT batteries

Reviewed ERCOT battery operations before and after RTC+B.

| Tool | What it does |
| --- | --- |
| `get_project_battery_operations` | **Get ERCOT battery operations.** Battery resource coverage or one month of operational energy. |
| `analyze_battery_period` | **Analyze ERCOT battery operations.** Battery operations over up to 24 months for up to 5 plants, with the two metering regimes kept apart. |

### Source records

Row-level reads, calculations and rankings over loaded source tables.

| Tool | What it does |
| --- | --- |
| `query_source_records` | **Query source records.** Find exact entity IDs, then read compact records with units and citations. |
| `summarize_source_records` | **Summarize source records.** Totals and heat rates across every matching record for 1–5 entities and at most 60 months. |
| `rank_source_records` | **Rank source records.** Rank all records at the dataset’s own grain before taking the top rows. |

### Grid and weather

Hourly load, fuel mix and carbon intensity by balancing authority, and point weather at every wind and solar plant.

| Tool | What it does |
| --- | --- |
| `get_grid_hourly` | **Get hourly load, fuel mix and carbon.** EIA-930 demand, forecast, net generation, interchange, generation by fuel and hourly CO₂ intensity for up to 4 ISOs or balancing authorities, up to 92 days, updated hourly. |
| `get_plant_weather` | **Get plant weather.** Hourly hub-height wind, irradiance and temperature at a wind or solar plant from 2010, for windows up to 31 days. |
| `explain_output_with_weather` | **Check output against weather.** Monthly capacity factor against what the plant's own weather predicts, with months below 60% of expected flagged. A model estimate. |

### Water

Plant cooling water and the water stress of each plant’s watershed.

| Tool | What it does |
| --- | --- |
| `get_plant_water_use` | **Get plant cooling water and water stress.** EIA cooling water withdrawal and consumption by plant, joined to the USGS surface water stress index at the plant location, for about 730 plants. |

## Data

Counts as of November 1, 2026. The live figures, periods and caveats for every dataset are on the [data sources page](https://www.inframap.pro/docs/data-sources?utm_source=github&utm_medium=readme).

- **Power plants:** 14,233 operating plants and batteries, grouped into 14,225 projects with 1,391 GW of nameplate capacity, from EIA-860M (August 2026).
- **Generation:** monthly net generation from EIA-923, January 2000 to July 2026.
- **Emissions and water:** EPA emissions from 1995 to 2025, cooling water use and water stress.
- **Prices:** hourly day-ahead and real-time node prices, hub prices and basis at 3,466 plant pricing nodes in CAISO, ERCOT, ISO-NE, MISO, NYISO, PJM and SPP, plus live five-minute real-time hub prices for all seven.
- **Load and fuel mix:** hourly EIA-930 demand, forecast, interchange and generation by fuel for every balancing authority, from July 2015.
- **Ownership and offtake:** owners and parent companies for 3,150 projects, and 2,610 offtake contracts from 473 buyers.
- **Modeled data:** physical potential, expected generation and modeled curtailment, always labeled as models.

How results are reported:

- Observed, calculated and modeled values stay separate and are labeled.
- Missing is not zero: a null means the source has no usable record. Zero and negative values are shown as reported.
- Each dataset keeps its own period, and every result states it.
- A pricing node, hub or balancing area linked to a plant is an association, not proof of settlement, a contract or a physical connection.

The [methodology page](https://www.inframap.pro/docs/methodology?utm_source=github&utm_medium=readme) explains how plants are grouped and how capacity factor, potential, curtailment, prices and basis are calculated.

## Limits

- About 120 requests a minute and 2 at a time per account. Prefer one `query_analyst_store` query over many single-plant calls.
- `query_analyst_store` runs one read-only SQLite `SELECT` over a documented schema and returns up to 200 rows.
- US data only. The server does not give investment advice, residential retail rates or customer account data.

## Security and privacy

- [Security](https://www.inframap.pro/security) and [vulnerability reports](https://www.inframap.pro/security#vulnerability-disclosure). See also [SECURITY.md](SECURITY.md).
- [Privacy policy](https://www.inframap.pro/privacy), which covers MCP request logs and OAuth tokens
- [Terms of service](https://www.inframap.pro/terms) and [acceptable use](https://www.inframap.pro/acceptable-use)
- [Subprocessors](https://www.inframap.pro/subprocessors)

## Support

Email contact@inframap.org, or open an issue in this repository for documentation and setup problems.

## About

InfraMap Pro is a US power market data platform for energy analysts, developers, asset managers, offtakers and traders, with a web map, an AI analyst and this MCP server. InfraMap Edu (edu.inframap.org) is a separate, free app for learning how the grid works and does not include Pro's data or this server. InfraMap Pro is not affiliated with Open Infrastructure Map, Cycloid's InfraMap tool for Terraform diagrams, InfraMap Corp. or iWater's infraMAP.

## License

The documentation and configuration files in this repository are released under the [MIT License](LICENSE). Use of the InfraMap service and its data is governed by the [Terms of service](https://www.inframap.pro/terms).
