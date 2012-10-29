module Nukumber

  module Reporter

    class Html < Abstract

      private

      def css()
        <<HERE
<!--

/* http://meyerweb.com/eric/tools/css/reset/
    end
   v2.0 | 20110126
   License: none (public domain)
*/

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center, dl, dt, dd, ol, ul, li,
fieldset, form, label, legend, table, caption,
tbody, tfoot, thead, tr, th, td, article, aside,
canvas, details, embed, figure, figcaption,
footer, header, hgroup, menu, nav, output, ruby,
section, summary, time, mark, audio, video {
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 100%;
  font: inherit;
  vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
  display: block;
}
body {
  line-height: 1;
}
ol, ul {
  list-style: none;
}
blockquote, q {
  quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
  content: '';
  content: none;
}
table {
  border-collapse: collapse;
  border-spacing: 0;
}

/* ========================== END MEYER RESET ========================== */



html {
  font-family: monospace;
}

body {
  padding: 10px;
  line-height: 1.4;
}

h1 { font-size: 150%; font-weight: bold; }
h2 { font-size: 130%; font-weight: bold; }
h3 { font-size: 110%; font-weight: bold; }

table, th, td { border: 1px solid #000; padding: 3px; }
th { background-color: #FFF }

.feature {
  padding: 10px;
  margin-bottom: 10px;
}

.element {
  width: 100%;
  overflow: auto;
  border: 1px dashed #000;
  padding: 10px;
  margin-bottom: 10px;
}

.header { margin-bottom: 1ex; min-height: 2.5ex; }
.header h3 { float:left; }
.header .address { float:right; font-size: 80%; }

.header .tags { font-weight: bold; }

.header p,
.header .tags,
.step {
  clear: both;
}

.step { margin-bottom: 4px; }

.passed {
  background-color: #8E6;
}

.element.passed {
  background-color: #BFB;
}

.failed {
  background-color: #D00;
}

.element.failed {
  background-color: #FCC;
}

.pending, .outline {
  background-color: #2FE;
}

.element.pending, .element.outline {
  background-color: #CFF;
}

.undefined {
  background-color: #FF2;
}

.error {
  padding: 10px;
}

.error div {
  background-color: #000;
  color: #F00;
  padding: 10px;
}

#final_report {
  position: fixed;
  top: 0;
  right: 0;
  border: 1px solid #000;
}

#final_report div {
  padding: 6px;
}

#final_report .datetime {
  background-color: #FFF;
}

-->
HERE
      end

    end

  end

end
