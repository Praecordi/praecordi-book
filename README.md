# Praecordi Book Class

A modern LaTeX class for creating beautifully typeset novels, short story collections and anthologies. It was created as a set of commands to aggregate multiple chapters and fragments when writing, keeping track of progress and maintaining a place for ideas. It developed into an extensive set of interconnected tools.

## Features

### Book Structure
- **Chapter & Fragment Management**

  Organized inclusion with metadata support:
  ```latex
  % mychapter.tex
  \chaptermetadata{title=My Chapter, subtitle=Optional, coverart=image.jpg}
  ```

  ```latex
  % book.tex
  \include{chapter-file}
  ```

- **Dual Content Types**

  Separate `chapter` (main content) and `fragment` (side content) system.


### Custom Environments
- **Notes & Ideas**

  Contextual boxes with draft-mode visibility control:
  ```latex
  \begin{notes}{Reference Title}{label}
      Some commentary here\dots
  \end{notes}
  ```

- **Progress Tracking**

  Automated progress tables showing page/word counts:
  ```latex
  \begin{progresstable}
    \progressrow{ch01}{Chapter Title}{1500}{In Progress}
  \end{progresstable}
  ```

### Design Features
- **Dark Mode Support**

  Activate with class option `\documentclass[darkmode]{praecordi-book}`
- **Art Integration**

  Cover art, chapter-specific art, and decorative vignettes:
  ```latex
  \coverart[0.8\pagewidth]{cover.jpg}
  \vignette[angle=15]{south west}{vignette.pdf}
  ```

### Production Tools
- **Draft Mode**

  Watermarks and conditional content with `\documentclass[wip]{praecordi-book}`
- **Linkable Elements**

  Cross reference chapters/fragments with `\chapref{ch01}{Link Text}`
- **Flexible Highlighting**

  Customizable text highlighting with `\chl[color]{text}`

## Installation

### Method 1: Per-project Installation

1. Place these files in your project directory:
    * `praecordi-book.cls`
    * `praecordi-book-util.cls`
2. Declare the document class

  ```latex
  \documentclass{praecordi-book}
  ```

### Method 2: System-wide Installation
1. Find your TeX directory:

  ```bash
  kpsewhich -var-value TEXMFHOME
  ```
2. Create directory structure:

  ```bash
  mkdir -p $(kpsewhich -var-value TEXMFHOME)/tex/latex/praecordi
  ```
3. Copy files:

  ```bash
  cp praecordi-book.cls praecordi-book-util.sty $(kpsewhich -var-value TEXMFHOME)/tex/latex/praecordi/
  ```
4. Refresh TeX file database:

  ```bash
  mktexlsr
  ```

## License

This work may be distributed and/or modified under the
conditions of the GNU General Public License, version 3 (GPLv3).
The full text of the license is provided in the file LICENSE
included with the source code, or may be obtained at
<https://www.gnu.org/licenses/gpl-3.0.html>.

SPDX-License-Identifier: GPL-3.0-only