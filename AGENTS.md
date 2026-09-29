# AGENTS.md

## PR review

I'm still learning Odin, so please review my changes with extra attention to things I might commonly miss.

- Look for memory leaks, use-after-free, dangling pointers, double frees, and lifetime issues
- Check allocator usage and cleanup paths
- Watch for invalidated pointers or slices
- Point out syntax or language mistakes
- Suggest more idiomatic Odin when there is a clearly better approach
- Mention important edge cases I may have missed
- Call out meaningful performance issues
- Point out missing tests when they would catch a real bug
- Add short educational notes when there is an Odin concept worth explaining

Prioritize real bugs and useful insights over style or nitpicks.

Clearly distinguish between:

- Bugs
- Suggestions
- Learning notes
