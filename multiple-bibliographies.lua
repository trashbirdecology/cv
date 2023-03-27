-- file: multiple-bibliographies.lua

--- collection of all cites in the document
local all_cites = {}
--- document meta value
local doc_meta = pandoc.Meta{}

--- Create a bibliography for a given topic. This acts on all divs whose ID
-- starts with "refs", followed by nothings but underscores and alphanumeric
-- characters.
local function create_topic_bibliography (div)
  local name = div.identifier:match('^refs([_%w]*)$')
  if not name then
    return nil
  end
  local tmp_blocks = {
    pandoc.Para(all_cites),
    pandoc.Div({}, pandoc.Attr('refs')),
  }
  local tmp_meta = pandoc.Meta{bibliography = doc_meta['bibliography' .. name]}
  local tmp_doc = pandoc.Pandoc(tmp_blocks, tmp_meta)
  local res = pandoc.utils.run_json_filter(tmp_doc, 'pandoc-citeproc')
  -- first block of the result contains the dummy para, second is the refs Div
  div.content = res.blocks[2].content
  return div
end

local function resolve_doc_citations (doc)
  -- combine all bibliographies
  local meta = doc.meta
  local orig_bib = meta.bibliography
  meta.bibliography = pandoc.MetaList{orig_bib}
  for name, value in pairs(meta) do
    if name:match('^bibliography_') then
      table.insert(meta.bibliography, value)
    end
  end
  doc = pandoc.utils.run_json_filter(doc, 'pandoc-citeproc')
  doc.meta.bibliography = orig_bib -- restore to original value
  return doc
end

return {
  {
    Cite = function (c) all_cites[#all_cites + 1] = c end,
    Meta = function (m) doc_meta = m end,
  },
  {Pandoc = resolve_doc_citations,},
  {Div = create_topic_bibliography,}
}