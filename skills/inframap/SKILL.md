---
name: inframap
description: Use the inframap MCP server for US power plant, generation, ownership, emissions, market price, curtailment, battery and cooling water questions, and report its results with sources, units, coverage and observed versus modeled labels.
---

# InfraMap energy data (MCP)

Use the `inframap` MCP server (https://mcp.inframap.pro/mcp) for questions about US power plants and the grid: the plant inventory, generation and capacity factors, ownership, emissions, market prices and basis, modeled curtailment, ERCOT batteries and cooling water. The server is read-only. It needs an InfraMap Pro, Team or Enterprise account: if a tool call fails because you are not signed in, ask the user to sign in through their client's MCP settings instead of retrying.

### Finding data

- If you are unsure which dataset answers the question, call `discover_energy_data` first. `get_data_catalog` and `get_source_catalog` describe each dataset. `get_analysis_guide` covers method and `get_energy_reference` covers definitions.
- To screen, count or rank across the whole inventory, use `query_analyst_store`. It runs one read-only SQLite SELECT, and its description holds the schema. It returns at most 200 rows, scans at most 100,000 and stops after 8 seconds, so aggregate and filter in SQL.
- For one plant, get its exact project ID from `search_energy_projects`, then call `get_project_profile`, `get_project_evidence_bundle` or the matching `get_project_*` tool.
- Before joining InfraMap results to source records or outside data, call `get_project_source_coverage`. One InfraMap project ID can group several EIA plants, and native source IDs differ from project IDs.

### Reporting results

- Put each dataset's reporting period, units and coverage next to the numbers.
- Keep missing values missing. Never fill a gap or treat null as zero. Keep zero and negative values as reported.
- Label every figure as observed (reported by a source), calculated (by you from observed values) or modeled (an InfraMap model).
- Curtailment from this server is a modeled estimate, never operator-reported curtailment. Give it as a range. `modeledCurtailmentMWh` is the lower bound and assumes each generator earns the production tax credit for its first 10 years. `noCreditCurtailmentMWh` is the upper bound and assumes no credit.
- Modeled generation potential is not delivered generation. A price-node association does not prove settlement, a contract or a physical connection.
- Cite the source records each tool returns. If the evidence cannot support a conclusion, say exactly what is missing. `explain_analysis_limit` explains known limits.

### Writing code and files

- Save InfraMap project IDs, units, reporting periods and the `dataRelease` value from each result's `delivery` block next to any values you write to disk.
- Note which tool and arguments produced each table so someone can repeat the pull.
- The server allows about 120 requests a minute and 2 at a time. Prefer one aggregate SQL query over many single-plant calls.
