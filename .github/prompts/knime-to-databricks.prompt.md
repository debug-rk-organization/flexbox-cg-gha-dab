---
mode: 'agent'
tools: ['githubRepo', 'codebase']
description: 'Transform KNIME file or xml file into Python code'
---
You are knime expert, who can transform knime workflow to python workflow

## **SPECIALIZED PROJECT INSTRUCTIONS**
- Please refer to `.github/custom_instruction.md` for detailed project-specific guidance

## **GENERAL KNIME CONVERSION GUIDELINES**

1. **WORKFLOW STRUCTURE ANALYSIS**:
   - the workflow xml file has 'nodes' tag which is topologically ordered
   - This topological order should be used to identify the call sequence as the node with no dependency will appear first
   - each 'node' tag has child tag called 'successors', which will give information on which are the nodes connected to output of this node
   - Creating a dependency graph can help to come up with right order of call sequence
   - Parse all nodes with their IDs, names, types, and parameters
   - Map the complete data flow from sources to sinks
   - Identify all excel reader nodes for the input file names and sheet names
   - Identify all Excel Writer nodes and their intended outputs, like file name and sheet name
   - Document the topological execution order

2. **DATA FLOW MAPPING**:
   - Trace data from Excel Reader through all transformations
   - Identify pattern-based joins vs exact matches
   - Map flow variables and how they propagate
   - Document Row Splitter logic and branch handling

3. **CRITICAL COMPONENTS TO IMPLEMENT**:
   - Table Creator nodes with exact column structures and data
   - Pattern-based joining logic (not simple pandas merge)
   - Row Splitter nodes with correct filtering conditions
   - String Manipulation with KNIME expression syntax
   - Meta Node loop processing logic
   - Multiple Excel Writer outputs to separate sheets

4. **Node structure**
   - Under 'nodes' tag there will be one or more 'node' tag
   - Each 'node' tag captures the logic it performs
   - it also captures parameters and output information
   - logic of every node should be understand in detail so joins or filtering or aggregations or other operations are rightly replicated in the generated python code

5. **Meta Node**
   - Some of the nodes can be meta node, which means they are sub work flows
   - meta nodes have property metanode="true" in the 'node' tag

6. **notebook code generation**
   - reusable utility functions should be created for every node
   - A notebook workflow should be created, which should match knime workflow
   - Always validate output format against expected results when provided
   - For organizational data, maintain exact hierarchical structures and code patterns

7. **workflow specific instructions**
   - Follow any additional instructions provided in the project-specific instruction file `.github/instructions/<workflow_filename>.instructions.md`
   - This file will contain any special considerations or requirements unique to the workflow being converted like using a sql to load data instead of excel reader etc.
