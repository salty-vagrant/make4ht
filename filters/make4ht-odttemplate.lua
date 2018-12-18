local filter = require "make4ht-filter"
local mkutils = require "mkutils"
local zip = require "zip"

-- filter_settings "odttemplate" {
--   filename = "test.odt"
-- }

local function get_template_filename(settings)
  -- either get the template odt filename from tex4ht.sty options (make4ht filename.tex "odttemplate=test.odt")
  local tex4ht_settings = settings.tex4ht_sty_par
  local templatefile = tex4ht_settings:match("odttemplate=([^%,]+)")
  if templatefile then return templatefile end
  -- read the template odt filename from settings
  local filtersettings = get_filter_settings "odttemplate"
  return filtersettings.filename
end

return function(content, settings)
  -- use settings added from the Make:match, or default settings saved in Make object
  local settings = settings or Make.params
  local templatefile = get_template_filename(settings)
  -- don't do anything if the template file doesn't exist
  if not templatefile or not mkutils.file_exists(templatefile) then return content end
  local odtfile = zip.open(templatefile)
  local stylesfile = odtfile:open("styles.xml")
  -- just break if the styles cannot be found
  if not stylesfile then return content end
  local styles = stylesfile:read("*all")
  return styles
end
