# Example prompts

These are the prompts InfraMap's directory reviewers run. Each one names the tools it should use.

## In scope

### One plant's reported monthly generation with citations

> Show Barry's reported monthly generation for 2024, including any missing months and the source for each value.

Tools: `search_energy_projects`, `get_project_evidence_bundle`

Resolves Barry (Alabama Power, EIA plant 3), then returns 2024 monthly EIA-923 net generation with source citations. Missing months are reported as missing, not zero.

### Inventory-wide count with the analyst store

> How many plants in each ISO have a reviewed market price node, and how many have none?

Tools: `query_analyst_store`

Runs one read-only SQL query grouped by ISO and price_node_status and reports the counts with the analyst store version and table citation.

### Modeled curtailment ranking with both bounds

> Which wind and solar plants had the largest increase in modeled curtailment from 2024 to 2025? Show both the credit and no-credit bounds.

Tools: `compare_project_curtailment`

Ranks plants by the change between 2024 and 2025 and gives the lower (production tax credit) and upper (no credit) bounds. Labels the results as modeled estimates, not operator-reported curtailment.

### Modeled revenue for a named plant

> Estimate Moccasin's wholesale energy revenue for January through June 2025 and say which price node you used.

Tools: `search_energy_projects`, `model_project_revenue`

Finds Moccasin (CAISO hydro, project 381) and returns modeled revenue from monthly EIA generation times the mean price at its mapped node, naming the node and labeling the figure as modeled.

### Water use joined to modeled water stress

> Which coal plants reported the most cooling water withdrawal, and what is the water stress at each site?

Tools: `get_plant_water_use`

Lists coal plants ranked by reported EIA cooling water withdrawal in million gallons, with the modeled USGS surface water stress index for each location, keeping reported and modeled values separate.

## Out of scope

The assistant should not call InfraMap for these.

- **What is the largest power plant in Germany?** Non-US plants are out of scope. InfraMap covers US power plants only, so the plugin should not be called; the assistant should answer from general knowledge or say InfraMap covers only the US.
- **Should I buy shares of NextEra Energy right now?** Investment advice is out of scope. InfraMap reports plant and market data, not stock recommendations, so the plugin should not be called; the assistant should answer without InfraMap and avoid personalized investment advice.
- **How much will my home electricity bill be next month?** Household bills are out of scope. InfraMap has wholesale market prices, not residential retail rates or customer accounts, so the plugin should not be called; the assistant should explain it cannot see the user's bill.
