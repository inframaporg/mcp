#!/bin/sh
# Add InfraMap to Claude Code for every project, then sign in.
claude mcp add --transport http --scope user inframap https://mcp.inframap.pro/mcp
claude mcp login inframap
