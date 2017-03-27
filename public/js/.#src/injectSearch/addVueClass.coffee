class AddVueClass
  tempradionamearray: []

  constructor: ->
    @inputCount=0

  action: ->
    self=@
    $("input[type='text']").each ->
      # console.log @
      # console.log self.inputCount
      $(this).attr "v-model", "inputDataArray[#{ self.inputCount}].value"
      # $(this).attr "value", ""
      $(@).attr 'timbr_count', self.inputCount

      self.inputCount++
      return
    $("input[type='checkbox']").each ->
      # console.log self.inputCount
      $(this).attr "v-model", "inputDataArray[#{ self.inputCount}].checked"
      # $(this).attr "v-model", "inputDataArray[#{ self.inputCount }]"
      $(@).attr 'timbr_count', self.inputCount

      self.inputCount++
      return

    self.inputCount--

    $("input[type='radio']").each ->
      if @name in self.tempradionamearray
        $(this).attr "v-model", "inputDataArray[#{ self.inputCount}].picked"
      # $(this).attr "v-model", "inputDataArray[#{ self.inputCount }]"
        $(@).attr 'timbr_count', self.inputCount
        # console.log self.inputCount
      else
        self.inputCount++
        $(this).attr "v-model", "inputDataArray[#{ self.inputCount}].picked"
        $(@).attr 'timbr_count', self.inputCount

        self.tempradionamearray.push @name
      return
    self.inputCount++
    $("select").each ->
      $(this).attr "v-model", "inputDataArray[#{ self.inputCount }].selected"
      $(this).attr "options", "inputDataArray[#{ self.inputCount }].options"
      $(@).attr 'timbr_count', self.inputCount

      # console.log self.inputCount

      self.inputCount++
      return

module.exports =
  addvueclass: new AddVueClass
