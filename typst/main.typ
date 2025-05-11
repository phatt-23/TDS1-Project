// Link Settings
#show link: set text(fill: rgb(0, 0, 100)) // make links blue
#show link: underline // underline links

// Heading Settings
#show heading.where(level: 1): it => {    
  text(2em)[#it.body]
}
#show heading.where(level: 2): set text(size: 1.1em)
#show heading.where(level: 3): set text(size: 1.2em)
#set heading(numbering: "1.")

// Raw Blocks
#set raw(theme: "./theme/Material-Theme.tmTheme")
#show raw: set text(font: "JetBrainsMono NF", size: 8pt)
#show raw.where(block: true): it => block(
  inset: 8pt,
  radius: 5pt,
  text(it),
  stroke: (
    left: 2pt + luma(230),
  )
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Font and Language
#set text(
  lang: "en",
  // font: "Latin Modern Mono",
  size: 11pt,
)

// Paper Settings
#set page(paper: "a4")

#include "./formalities/title.typ"

// Paper Settings
#set page(
  fill: none,
  margin: (
    left: 1in, right: 1in
    // left: 1.3in, 
    // right: 1.2in, 
  ),
  footer: context
  [
    _Technologie databázových systémů 1_
    #h(1fr)
    #counter(page).display(
      "1/1",
      both: true,
    )
  ],
)

// Paragraph Settings
#set par(
  justify: true,
  first-line-indent: 1em,
  linebreaks: "optimized",
)

// Text margins
#set block(spacing: 2em)
#set par(leading: 0.8em)

// Start the Page Counter
#counter(page).update(1)

// Outline
#v(6em)
#include "./formalities/outline.typ"
#pagebreak()


#include "./sections/database_design.typ"
#include "./sections/programming_with_sql.typ"


