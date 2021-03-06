class cola.ButtonMenu extends cola.Menu
	onItemClick: (event, item)->
		@_parent?.onItemClick(event, item)
		return null

	_toDropDown: (item)->
		unless @_parent instanceof cola.MenuButton
			super(item)
		return null

class cola.MenuButton extends cola.Button
	@tagName: "c-menuButton"
	@CLASS_NAME: "dropdown button"

	@attributes:
		menuItems:
			setter: (value)-> @_resetMenu(value)
			getter: ()-> @_menu?.get("items")
	@events:
		menuItemClick: null
	_setDom: (dom, parseChild)->
		super(dom, parseChild)
		if @_menu
			menuDom = @_menu.getDom()
			if menuDom.parentNode isnt @_dom
				@_dom.appendChild(menuDom)

		@get$Dom().dropdown()
		return

	_parseDom: (dom)->
		child = dom.firstElementChild
		while child
			if child.nodeType == 1
				menu = cola.widget(child)
				if menu and menu instanceof cola.Menu
					@_menu = menu
					menu._parent = @
					break
			child = child.nextElementSibling
		return

	onItemClick: (event, item)->
		@fire("menuItemClick", @,
			item: item
			event: event)
		return

	_resetMenu: (menuItems)->
		@_menu?.destroy()
		@_menu = new cola.ButtonMenu({
			items: menuItems
		})
		@_menu._parent = @
		@get$Dom().append(@_menu.getDom()) if @_dom
		return

	destroy: ()->
		return if @_destroyed
		@_menu?.destroy()
		delete @_menu
		super()
		return

	addMenuItem: (config)->
		@_menu?.addItem(config)
		return @

	clearMenuItems: ()->
		@_menu?.clearItems()
		return @

	removeMenuItem: (item)->
		@_menu?.removeItem(item)
		return @

	getMenuItem: (index)->
		return @_menu?.getItem(index)

cola.registerWidget(cola.MenuButton)

cola.registerType("menuButton", "_default", cola.ButtonMenu)
cola.registerType("menuButton", "menu", cola.ButtonMenu)

cola.registerTypeResolver "menuButton", (config)->
	return cola.resolveType("widget", config)
