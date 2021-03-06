class cola.MultiSelect extends cola.CustomDropdown
	@CLASS_NAME: "ui tag-editor"
	@tagName: "c-multiSelect"
	@events:
		renderItem: null
		beforeRemoveItem: null
		removeItem: null
	_setValueContent: ()->
		value = @_value
		values = []
		if value
			values = value.split(",")
		$(@_dom).find(".tag").remove()
		$input = $(@_dom).find(">input")
		for val in values
			itemDom = $.xCreate({
				tagName: "div", class: "tag",
				content: [
					{
						tagName: "span",
						content: val
					},
					{
						tagName: "i",
						"c-onclick": "removeItem(item)",
						class: "delete-icon",
						content: "×"
					}
				]
			})
			$(itemDom).data({
				item: val
			})
			@fire("renderItem", @, {itemDom: itemDom, item: val, value: value})
			$input.before(itemDom)

	removeItem: (item)->
		if !item then return

		if @_readOnly then return
		if item.nodeType
			data = $(item).data().item
		else
			data = item

		value = @_value
		values = value.split(",")
		newValues = [];
		for val in values
			if val == data then continue;
			newValues.push(val)
		newValue = newValues.join(",")
		if @fire("beforeRemoveItem", @, {item: data, oldValue: value, value: newValue}) isnt false
			@_set("value", newValue)
		@fire("removeItem", @, {item: data, oldValue: value, value: newValue})


	_selectData: (item)->
		@_inputEdited = false
		cValue = @_value || ""

		if cValue
			values = cValue.split(",")
		else
			values = []

		for val in values
			if val == item then return;

		values.push(item);
		value = values.join(",")
		@_skipFindCurrentItem = true
		if @fire("selectData", @, {item: item, oldValue: cValue, value: value}) isnt false
			@_currentItem = item
			@set("value", value)

		@_skipFindCurrentItem = false
		@refresh()
		return

	_initDom: (dom)->
		super(dom)
		multiSelect = @
		$(dom).delegate(".tag", "click", ()->
			multiSelect.removeItem(@)
		)
		@_doms.input = dom;


cola.registerWidget(cola.MultiSelect)