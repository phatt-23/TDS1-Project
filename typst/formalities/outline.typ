
#show outline.entry.where(
  level: 2
): it => {
  v(12pt, weak: true)
  // strong(it)
  it
}

#outline(
  indent: auto,
  title: box(
    inset: (bottom: 0.8em),
    text[Obsah],
  ),
)
