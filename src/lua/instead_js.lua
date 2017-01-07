INSTEAD_PLACEHOLDER = function()
    return
end

-- call JS function with given parameters
insteadjs_call = function(jsfn, arg)
    local arguments = ''
    for i,v in ipairs(arg) do
        arguments = arguments .. '"' .. tostring(v) .. '",'
    end
    arguments = arguments:sub(1, -2)
    js.run(jsfn .. '(' .. arguments .. ')')
end

table_get_maxn = function(tbl)
	local c=0
	for k in pairs(tbl) do
		if type(k)=='number' and (c == nil or k > c) then
			c=k
		end
	end
	return c
end

js_instead_gamepath = function(path)
  INSTEAD_GAMEPATH=path
end

instead_gamepath=function()
  return INSTEAD_GAMEPATH
end

instead_realpath=function()
  return nil
end

-- theme
function instead_theme_var(name, value)
    -- TODO: get theme variable from JS
    if (value) then
        js.run('insteadTheme("' .. tostring(name) .. '","' .. tostring(value) .. '")')
    end
end

function js_instead_theme_name(theme)
  INSTEAD_THEME_NAME=theme
end

function instead_theme_name()
    return INSTEAD_THEME_NAME
end

-- timer
instead_timer = function(t)
    js.run('instead_settimer("' .. tostring(t) .. '")')
end

-- sprites are not supported (yet?)
sprite_descriptors = {}

instead_font_load = function()
    print('NOT IMPLEMENTED: sprite.font_load')
end
instead_font_free = function()
    print('NOT IMPLEMENTED: sprite.font_free')
end
instead_font_scaled_size = function()
    print('NOT IMPLEMENTED: sprite.font_scaled_size')
end
instead_sprite_alpha = function()
    print('NOT IMPLEMENTED: sprite.sprite_alpha')
end
instead_sprite_dup = function()
    print('NOT IMPLEMENTED: sprite.dup')
end
instead_sprite_scale = function()
    print('NOT IMPLEMENTED: sprite.scale')
end
instead_sprite_rotate = function()
    print('NOT IMPLEMENTED: sprite.rotate')
end
instead_sprite_text = function()
    print('NOT IMPLEMENTED: sprite.text')
end
instead_sprite_text_size = function()
    print('NOT IMPLEMENTED: sprite.text_size')
end
instead_sprite_draw = function(...)
    insteadjs_call('Sprite.draw', {...})
end
instead_sprite_copy = function(...)
    insteadjs_call('Sprite.copy', {...})
end
instead_sprite_compose = function(...)
    insteadjs_call('Sprite.compose', {...})
end
instead_sprite_fill = function(...)
    insteadjs_call('Sprite.fill', {...})
end
instead_sprite_pixel = function(...)
    insteadjs_call('Sprite.pixel', {...})
end
instead_sprite_load = function(filename)
    js.run('Sprite.load("' .. tostring(filename) .. '")')
    return sprite_descriptors[filename]
end
js_instead_sprite_load = function(filename, id)
    sprite_descriptors[filename] = id
end
instead_sprite_free = function(descriptor)
    js.run('Sprite.free("' .. tostring(descriptor) .. '")')
end
instead_sprite_size = function()
    print('NOT IMPLEMENTED: sprite.size')
end
instead_sprites_free = INSTEAD_PLACEHOLDER
instead_sprite_colorkey = INSTEAD_PLACEHOLDER

-- initialization
require "stead"
require "gui"

stead.init(stead)

-- save/load support
function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  return str
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end

stead.io.open = function(filename, mode)
    return {
        name = filename,
        content = '',
        write = function(self, ...)
            local a = { ... }
            for i,v in ipairs(a) do
                self.content = self.content .. tostring(v);
            end
        end,
        flush = INSTEAD_PLACEHOLDER,
        close = function(self)
            js.run('Lua.saveFile("' .. self.name .. '", "' .. url_encode(self.content) ..'")')
        end
    }
end

instead_loadgame = function(content)
    file_content = url_decode(content)
    do
        -- redefine loadfile to return custom content
        loadfile = function()
            return assert(loadstring(file_content));
        end
        iface.cmd(iface, 'load INSTEAD_SAVED_GAME')
    end
end