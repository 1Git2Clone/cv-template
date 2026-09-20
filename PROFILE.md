# YOUR NAME -- Profile & CV Knowledge Base

This file is the source of truth an AI should reference, alongside a target job
posting, to generate a tailored one-page LaTeX CV. It intentionally keeps more
detail than any single CV should show -- pick the subset that's relevant to the
job at hand, and reword freely, but don't invent facts not present here.

## Contact

- Name: YOUR NAME
- Location: CITY, COUNTRY
- Phone: +00 000 000 000
- Email: <you@example.com>
- GitHub: <https://github.com/yourusername>
- LinkedIn: <https://www.linkedin.com/in/yourprofile>
- Homepage: <https://your-homepage.example.com>

## Positioning

Write a 2-3 sentence positioning statement that bridges your current role with
what you're targeting. Lead with what you do now, bridge to your strongest
differentiator. Example: "Systems engineer targeting infrastructure and
platform engineering. Currently building X with production experience in Y."

## Tech Stack

- Languages: Rust, Python, TypeScript
- Databases: PostgreSQL, MySQL, SQLite
- DevOps: Tool1, Tool2, Tool3
- Libraries/Frameworks: Lib1, Lib2, Lib3
- Infrastructure: Infra1, Infra2, Infra3
- Other: (any notable tools or skills)

## Experience

### COMPANY 1 NAME -- Role Title

City, Country -- Month YYYY -- Present

- Your strongest achievement, quantified
- Second strongest achievement
- Context notes that help an AI pick relevant bullets for a specific posting

### COMPANY 2 NAME -- Role Title

City, Country -- Month YYYY -- Month YYYY

- Your most relevant achievement from this role
- Any notable initiative beyond assigned tasks
- Honest context about the role's scope (helps an AI bridge career transitions)

## Contributions & Projects

### PROJECT 1 NAME -- Description

<https://your-project-url.example.com>

- What you built and why it matters
- Specific technical achievement
- Tools used

### PROJECT 2 NAME -- Description

<https://your-project-url.example.com>

- What you built and why it matters
- Specific technical achievement
- Tools used

## Education

UNIVERSITY -- Degree Name
Month YYYY -- Present

## Languages

- Language1 -- Level
- Language2 -- Level

## CV Generation Notes (for AI use)

- Goal: given a job posting, select and reword the most relevant subset of the
  above into a tailored one-page LaTeX CV -- don't just dump everything in.
- Keep to one page. Prefer cutting the least-relevant bullets over shrinking
  fonts/margins below what `cv.tex` currently uses.
- `cv.tex` is the current baseline template/style (packages, spacing, section
  layout) -- match its conventions when producing new tailored versions rather
  than inventing a new layout each time, unless asked to redesign.
