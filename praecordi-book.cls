\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{praecordi-book}[2025/05/01 Custom class for short story collections]

% Conditional for draft mode
\newif\ifwip
\wipfalse
\newif\ifnoimage
\noimagefalse
\newif\ifdarkmode
\darkmodefalse
\DeclareOption{wip}{\wiptrue}
\DeclareOption{noimage}{\noimagetrue}
\DeclareOption{darkmode}{\darkmodetrue}
\DeclareOption{showframe}{\PassOptionsToPackage{showframe}{geometry}}
\ProcessOptions\relax

% Base class and options
\LoadClass[
  DIV=10,
  fontsize=12pt,
  twoside={\ifwip false \else semi \fi},
  parskip=half+,
  chapterprefix=true
]{scrbook}

\RequirePackage{geometry}
\RequirePackage{scrlayer-scrpage} % For heading and footing
\RequirePackage{fontspec} % For typography
\RequirePackage[american]{babel} % For hyphenation and other language specific things
\RequirePackage{csquotes} % For dialogue
\RequirePackage{ragged2e} % For line positioning
\RequirePackage{indentfirst}
\RequirePackage[babel,nopatch=footnote]{microtype}
\RequirePackage[dvipsnames,svgnames,table]{xcolor}

% ------------------------
% Dark Mode Setup
% ------------------------
\ifdarkmode
  \colorlet{backgroundcolor}{black}
  \colorlet{textcolor}{white}
  \colorlet{subcolor}{lightgray}
\else
  \colorlet{backgroundcolor}{white}
  \colorlet{textcolor}{black}
  \colorlet{subcolor}{darkgray}
\fi

\newcommand{\defineflexiblecolor}[2]{
  \ifdarkmode
    \colorlet{#1bcolor}{#2!15!black}
    \colorlet{#1fcolor}{#2!75!black}
  \else
    \colorlet{#1bcolor}{#2!15!white}
    \colorlet{#1fcolor}{#2!75!white}
  \fi
}

\defineflexiblecolor{note}{Goldenrod}
\defineflexiblecolor{idea}{SkyBlue}
\defineflexiblecolor{frag}{Orchid}
\defineflexiblecolor{meh}{Peru}
\defineflexiblecolor{curious}{SlateBlue}
\defineflexiblecolor{invested}{DodgerBlue}
\defineflexiblecolor{hooked}{Tomato}
\defineflexiblecolor{done}{LimeGreen}

\RequirePackage{praecordi-book-util}
\usetikzlibrary{positioning, calc, fit, backgrounds}

% ------------------------
% Typography Setup
% ------------------------
\linespread{1.25}
\setmainfont{Cormorant Garamond}
\newfontfamily\ourfont{Cormorant Garamond}
\addtokomafont{disposition}{\ourfont}
\setkomafont{footnote}{\normalfont\RaggedRight}
\KOMAoptions{DIV=current}

\pagecolor{backgroundcolor}
\color{textcolor}
\addtokomafont{disposition}{\color{textcolor}}
\addtokomafont{subtitle}{\color{subcolor}}

% ------------------------
% Quote Styling Setup
% ------------------------
\DeclareQuoteStyle[american]{english}%
{\textquotedblleft}[\textquotedblleft]%
{\textquotedblright}%
[0.05em]%
{\textquoteleft}%
{\textquoteright}
\MakeOuterQuote{"}

% ------------------------
% Document beginning hook
% ------------------------
\AtBeginDocument{%
  \sloppy%
  \RaggedRight%
  \setlength{\parindent}{1em}%
}

% ------------------------
% Title Page
% ------------------------
\newcommand{\quicklinks}[1]{\def\@quicklinks{#1}}
\newkomafont{quicklinks}{\small\centering}

\pgfkeys{
  /vignette/.cd,
  width/.store in = \vignette@width,
  angle/.store in = \vignette@angle,
  width = 0.15\paperwidth,
  angle = 0
}

% Vignette commands
\newcommand{\vignette}[3][]{%
  \pgfkeys{/vignette/.cd, #1}% Process keys
  \edef\vignette@temp{%
    \noexpand\g@addto@macro\noexpand\@titlegraphics{%
      \noexpand\begin{tikzpicture}[remember picture,overlay]
        \noexpand\node[inner sep=0, outer sep=10pt, anchor=#2] at (current page.#2)
        {\noexpand\includegraphics[width=\vignette@width, angle=\vignette@angle]{#3}};
        \noexpand\end{tikzpicture}%
    }%
  }%
  \vignette@temp
}

% Cover art command
\newcommand{\coverart}[2][\paperwidth]{%
  \ifnoimage%
  \else%
    \g@addto@macro\@titlegraphics{%
      \begin{tikzpicture}[remember picture,overlay]
        \node[anchor=center] at (current page.center) {\includegraphics[width=#1]{#2}};
      \end{tikzpicture}%
    }%
  \fi
}

\renewcommand{\maketitle}{%
  \pagestyle{empty}
  \renewcommand*{\chapterpagestyle}{empty}
  \@titlegraphics
  \ifdefined\@subtitle
    \edef\authorpos{subtitle}
  \else
    \edef\authorpos{title}
  \fi
  \begin{tikzpicture}[
      remember picture,
      overlay,
      every node/.style={align=center, text width=0.55\paperwidth}
    ]
    \path (current page.center) ++ (0, 0.2\paperheight) coordinate (titlepos);

    \node[
      anchor=center,
      font=\usekomafont{title}\Huge
    ] (title) at (titlepos) {\@title};

    \ifdefined\@subtitle
      \node[
        below=0.5em of title,
        font=\usekomafont{subtitle}\normalsize
      ] (subtitle) {\@subtitle};
    \fi

    \node[
      below=1em of \authorpos,
      font=\usekomafont{author}\large
    ] (author) {By \@author};

    \ifwip
      \ifdefined\@quicklinks
        \node[
          below=1.5em of author,
          font=\usekomafont{quicklinks}
        ] (quicklinks) {\@quicklinks};
      \fi
    \fi

    \begin{scope}[on background layer]
      \node[
        fill=backgroundcolor,
        fill opacity=0.4,
        rounded corners=4pt,
        inner xsep=2cm,
        inner ysep=1cm,
        fit/.expanded={
            (title)
            \ifdefined\@subtitle (subtitle) \fi
            (author)
            \ifwip\ifdefined\@quicklinks (quicklinks) \fi\fi
          }
      ] (background) {};
    \end{scope}
  \end{tikzpicture}
  \global\let\@titlegraphics\@empty
}
\let\@titlegraphics\@empty

% ------------------------
% Background Art
% ------------------------
\newcommand{\backgroundart}[1]{%
  \ifnoimage%
  \else%
    \def\@backgroundart{#1}
  \fi
}

\AddToHook{shipout/background}{%
  \ifwip
  \else
    \ifdefined\@backgroundart
      \begin{tikzpicture}[remember picture, overlay]
        \node[opacity=0.2, anchor=center] at (current page.center)
        {\includegraphics[
            width=\paperwidth,
            height=\paperheight,
            keepaspectratio
          ]{\@backgroundart}};
      \end{tikzpicture}%
    \fi
  \fi
}

% ------------------------
% TOC Formatting
% ------------------------
\RedeclareSectionCommand[
  tocnumwidth=2.5em,
  beforeskip=0pt,
  afterskip=8\baselineskip
]{part}

\RedeclareSectionCommand[
  tocindent=1em,
  tocnumwidth=2.5em,
  beforeskip=0pt,
  afterskip=8\baselineskip
]{chapter}

\RedeclareSectionCommand[
  tocindent=2em,
  tocnumwidth=2.5em
]{section}

\let\origtoc\tableofcontents
\renewcommand{\tableofcontents}{%
  \pagestyle{empty}%
  \renewcommand*{\chapterpagestyle}{empty}%
  \origtoc\label{fm:content}%
  \clearpage%
  \pagestyle{scrheadings}%
  \renewcommand*{\chapterpagestyle}{plain}%
}

% ------------------------
% Draft watermark
% ------------------------
\ifwip
  \AddToHook{shipout/background}{%
    \begin{tikzpicture}[remember picture, overlay]
      \node[rotate=60,scale=10,opacity=0.1] at (current page.center) {DRAFT};
    \end{tikzpicture}%
  }
\fi

% ------------------------
% Header/footer setup
% ------------------------
\clearmainofpairofpagestyles
\clearpairofpagestyles
\setlength\headheight{30pt}
\setlength\footheight{75pt}

\automark[chapter]{chapter}
\renewcommand*{\chaptermarkformat}{}

\lehead{%
  \small%
  \begin{tikzpicture}
    \node[inner sep=0pt] (chap) {\headmark};
    \draw[line width=0.4pt] ([xshift=-2pt, yshift=-2.5ex]chap.west) -- ([xshift=20pt, yshift=-2.5ex]chap.east);
  \end{tikzpicture}
}

\rohead{%
  \small%
  \begin{tikzpicture}
    \node[inner sep=0pt] (chap) {\headmark};
    \draw[line width=0.4pt] ([xshift=-20pt, yshift=-2.5ex]chap.west) -- ([xshift=2pt, yshift=-2.5ex]chap.east);
  \end{tikzpicture}
}

\cfoot{%
  \begin{center}
    \begin{tikzpicture}
      \node[inner sep=0pt] (pagenum) {\pagemark};
      \draw[line width=0.5pt] (-\linewidth/2 + 6em, 0) -- ([xshift=-1em]pagenum.west);
      \draw[line width=0.5pt] ([xshift=1em]pagenum.east) -- (\linewidth/2 - 6em, 0);
    \end{tikzpicture}
  \end{center}
}

% ------------------------
% Chapter/part numbering
% ------------------------
\renewcommand\thepart{\arabic{part}}
\renewcommand\thechapter{\arabic{chapter}}

% ------------------------
% Footnote formatting
% ------------------------
\deffootnote[2em]{0.5em}{1em}{\textsuperscript{\thefootnotemark}} % Match main text indentation


\makeatletter
% ------------------------
% Chapter/part formatting
% ------------------------
\newcommand{\@chaptercoverart}{%
  \ifnoimage\else%
    \ifdefined\currentchapter
      \zref@ifrefcontainsprop{chap:\currentchapter}{chap@coverart}{%
        \edef\chapcoverfile{\zref@extract{chap:\currentchapter}{chap@coverart}}%
        \IfFileExists{\chapcoverfile}{
          \begin{tikzpicture}[remember picture, overlay]
            \node[opacity=1.0, anchor=center] at (current page.center)%
            {\includegraphics[
                width=\paperwidth,
                height=\paperheight,
                keepaspectratio
              ]{\chapcoverfile}};
          \end{tikzpicture}
        }{\ClassWarning{praecordi-book}{Chapter coverart '\chapcoverfile' not found}}%
      }{}%
    \fi
  \fi
}

\renewcommand*{\chapterlineswithprefixformat}[3]{%
  \begingroup
  \ifdefined\currentchapter%
    \zref@ifrefcontainsprop{chap:\currentchapter}{chap@subtitle}{%
      \def\chapsubtitle{\zref@extract{chap:\currentchapter}{chap@subtitle}}%
    }{}%
  \fi
  \Ifstr{#2}{}{%
    \flushleft
    \usekomafont{chapter}#3
  }{%
    \@chaptercoverart%
    \thispagestyle{empty}%
    \begin{tikzpicture}[
        remember picture,
        overlay,
        every node/.style={align=center},
        line/.style={line width=2pt}
      ]
      \path (current page.center) ++ (0, 0.35\paperheight) coordinate (chapterpos);

      \node[
        anchor=center,
        font=\usekomafont{chapter}
      ] (chap) at (chapterpos) {\chaptername~\thechapter};

      \coordinate[left=4em of chap.west] (left-end);
      \coordinate[right=4em of chap.east] (right-end);

      \draw[line] (left-end) -- (chap.west);
      \draw[line] (chap.east) -- (right-end);

      \node[
        below=0.5em of chap,
        font=\usekomafont{chapter}
      ] (title) {#3};

      \ifdefined\chapsubtitle
        \node[
          below=0.25em of title,
          font=\usekomafont{subtitle}\normalsize
        ] (subtitle) {\chapsubtitle};
      \fi

      \begin{scope}[on background layer]
        \node[
          fill=backgroundcolor,
          fill opacity=0.4,
          rounded corners=4pt,
          inner xsep=2cm,
          inner ysep=1cm,
          fit/.expanded={
              (left-end)
              (chap)
              (right-end)
              (title)
              \ifdefined\chapsubtitle (subtitle) \fi
            }
        ] (background) {};
      \end{scope}
    \end{tikzpicture}
    \clearpage%
  }%
  \endgroup
}

\renewcommand*{\partlineswithprefixformat}[3]{
  \thispagestyle{empty}
  \vspace*{\fill}
  \begin{center}
    \begin{tikzpicture}
      \draw[line width=2pt] (-\linewidth/2 + 1em, 0) -- (\linewidth/2 - 1em, 0);

      \Ifstr{#2}{}{%
        \node[below=1.5\baselineskip, anchor=center, align=center] (title) {\usekomafont{part}#3};
      }{%
        \node[below=1.5\baselineskip, anchor=center, align=center] (partnum) {\usekomafont{part}\partname~\thepart};
        \node[below=1.5\baselineskip of partnum, anchor=center, align=center] (title) {\usekomafont{part}#3};
      }

      \draw[line width=2pt]
      ($(-\linewidth/2 + 1em, 0 |- title.south) + (0, -0.5em)$) --
      ($(\linewidth/2 - 1em, 0 |- title.south) + (0, -0.5em)$);
    \end{tikzpicture}
  \end{center}
  \vspace*{\fill}
}
\makeatother
