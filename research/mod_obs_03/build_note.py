#!/usr/bin/env python3
"""Render MOD-OBS-03 scientific markdown to publication-quality DOCX."""
import re
from pathlib import Path
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.text import WD_BREAK
from docx.enum.style import WD_STYLE_TYPE
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

D=Path(__file__).parent
src=(D/'RAPPORT_SCIENTIFIQUE.md').read_text(encoding='utf-8')
out=D/'MOD_OBS_03_NOTE_SCIENTIFIQUE_2026-10-11.docx'
doc=Document()
sec=doc.sections[0]
sec.page_width,sec.page_height=Inches(8.5),Inches(11)
sec.top_margin=Inches(.67);sec.bottom_margin=Inches(.65)
sec.left_margin=Inches(.72);sec.right_margin=Inches(.72)
sec.header_distance=Inches(.32);sec.footer_distance=Inches(.32)

normal=doc.styles['Normal'];normal.font.name='Aptos';normal.font.size=Pt(10.35);normal.font.color.rgb=RGBColor(36,43,52)
normal.paragraph_format.space_after=Pt(5)
normal.paragraph_format.line_spacing=1.10
for name,sz,before,after in [('Title',18,8,12),('Heading 1',13,12,5),('Heading 2',11.5,9,5)]:
 st=doc.styles[name];st.font.name='Aptos Display';st.font.size=Pt(sz);st.font.bold=True;st.font.color.rgb=RGBColor(23,70,110)
 st.paragraph_format.space_before=Pt(before);st.paragraph_format.space_after=Pt(after)
 st.paragraph_format.keep_with_next=True
if 'Data line' not in doc.styles:
 mono=doc.styles.add_style('Data line',WD_STYLE_TYPE.PARAGRAPH)
else:mono=doc.styles['Data line']
mono.base_style=normal;mono.font.name='Consolas';mono.font.size=Pt(9)
mono.paragraph_format.space_after=Pt(3)
mono.paragraph_format.left_indent=Inches(.16)

if 'Report metadata' not in doc.styles:meta=doc.styles.add_style('Report metadata',WD_STYLE_TYPE.PARAGRAPH)
else:meta=doc.styles['Report metadata']
meta.base_style=normal;meta.font.size=Pt(9);meta.font.color.rgb=RGBColor(90,103,116)
meta.paragraph_format.space_after=Pt(3)

footer=sec.footer.paragraphs[0]
footer.alignment=WD_ALIGN_PARAGRAPH.RIGHT
run=footer.add_run('MOD-OBS-03   ·   11 octobre 2026   |   ')
run.font.size=Pt(8);run.font.color.rgb=RGBColor(110,117,126)
field=OxmlElement('w:fldSimple');field.set(qn('w:instr'),'PAGE')
footer._p.append(field)


def add_inline(p,s):
 parts=re.split(r'(\*\*.*?\*\*|\*[^*]+\*|`[^`]+`)',s)
 for piece in parts:
  if not piece:continue
  if piece.startswith('**') and piece.endswith('**'):
   r=p.add_run(piece[2:-2]);r.bold=True
  elif piece.startswith('*') and piece.endswith('*'):
   r=p.add_run(piece[1:-1]);r.italic=True
  elif piece.startswith('`') and piece.endswith('`'):
   r=p.add_run(piece[1:-1]);r.font.name='Consolas';r.font.size=Pt(9.3)
  else:
   # Markdown links -> readable title and parenthesized URL.
   text=re.sub(r'\[([^]]+)\]\((https?://[^)]+)\)',r'\1 (\2)',piece)
   p.add_run(text)


def add_table(rows):
 if not rows:return
 n=len(rows[0]);table=doc.add_table(rows=0,cols=n)
 table.alignment=WD_TABLE_ALIGNMENT.CENTER
 table.autofit=False
 if n==5: widths=[1.62, .75, 1.6, 1.58, 1.48]
 elif n==4:
  widths=[1.55,2.25,1.55,1.65]
 else:
  widths=[7.04/n]*n
 for i,row in enumerate(rows):
  cells=table.add_row().cells
  for j,val in enumerate(row):
   c=cells[j]
   c.width=Inches(widths[j])
   c.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
   tcPr=c._tc.get_or_add_tcPr()
   tcMar=OxmlElement('w:tcMar')
   for side in ('top','start','bottom','end'):
    z=OxmlElement('w:'+side);z.set(qn('w:w'),'80' if side in ('top','bottom') else '100');z.set(qn('w:type'),'dxa');tcMar.append(z)
   tcPr.append(tcMar)
   p=c.paragraphs[0];p.paragraph_format.space_after=Pt(0);p.paragraph_format.line_spacing=1.05
   if j>0:p.alignment=WD_ALIGN_PARAGRAPH.CENTER
   add_inline(p,val)
   for run in p.runs:
    run.font.size=Pt(8.1 if n>=6 else 8.5)
    if i==0:run.bold=True;run.font.color.rgb=RGBColor(255,255,255)
   if i==0:
    shd=OxmlElement('w:shd');shd.set(qn('w:fill'),'254761');tcPr.append(shd)
  if i==0:
   tblHeader=OxmlElement('w:tblHeader');tblHeader.set(qn('w:val'),'true');table.rows[-1]._tr.get_or_add_trPr().append(tblHeader)
 p=doc.add_paragraph();p.paragraph_format.space_after=Pt(1)

lines=src.splitlines();i=0
while i<len(lines):
 line=lines[i].rstrip()
 if not line:
  i+=1;continue
 if line.startswith('|') and '|' in line[1:]:
  rows=[]
  while i<len(lines) and lines[i].lstrip().startswith('|'):
   row=[x.strip() for x in lines[i].strip().strip('|').split('|')]
   if not all(re.match(r'^:?-{2,}:?$',c) for c in row):rows.append(row)
   i+=1
  add_table(rows);continue
 if line.startswith('# '):p=doc.add_paragraph(style='Title');add_inline(p,line[2:])
 elif line.startswith('## '):p=doc.add_paragraph(style='Heading 1');add_inline(p,line[3:])
 elif line.startswith('### '):p=doc.add_paragraph(style='Heading 2');add_inline(p,line[4:])
 elif line.startswith('    '):p=doc.add_paragraph(style='Data line');p.add_run(line[4:])
 elif line.startswith('- '):p=doc.add_paragraph(style='List Bullet');add_inline(p,line[2:]);p.paragraph_format.space_after=Pt(2)
 elif line.startswith('**') and ('Date :' in line or 'Statut :' in line or '11 octobre' in line):
  p=doc.add_paragraph(style='Report metadata');add_inline(p,line)
 else:
  p=doc.add_paragraph();add_inline(p,line)
 i+=1

# Ensure legal-safe, no personal names or external unsupported publishing claims in metadata.
doc.core_properties.title='MOD-OBS-03 — Risque probabiliste et coût de reconstruction'
doc.core_properties.subject='Recherche interne, test séquentiel, coût de certification et bornes KL'
doc.core_properties.keywords='MOD-OBS-03; STROBO-C3; Cayley; test sequentiel; certification'
doc.save(out)
print(str(out))
