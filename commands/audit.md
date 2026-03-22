Audit $ARGUMENTS. Emphasise preserving our intentions and reasons. If you think relevant information is missing, first check that it is not already in a future or completed plan.

### The Protocol

1. **Enumerate** -- Parse the source document into a numbered list of discrete, verifiable items. Each item is one requirement, constraint, behaviour, or detail that can be independently checked.
2. **Map** -- For each source item, search the target document(s) for coverage. Classify each as:
   - **Full** -- The item appears in the target with sufficient detail
   - **Partial** -- The item is mentioned but missing detail, specificity, or context
   - **Missing** -- The item does not appear in the target at all
3. **Calculate** -- Coverage % = (full + 0.5 x partial) / total x 100
4. **Fix** -- For missing and partial items, update the target document to include them. Don't invent requirements -- only add what the source explicitly contains.
5. **Recalculate** -- After fixes, recalculate coverage. Should be at or near 100%.
6. **Store** -- Append a verification section to the target document with the coverage map, metrics, and list of fixes applied.
7. **Clarify** -- If there are still information gaps you cannot resolve after doing your best, use /interview to ask clarifying questions.
