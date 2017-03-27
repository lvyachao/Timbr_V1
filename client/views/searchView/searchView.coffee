Template.searchView.rendered = ->
  Vue.component 't-Search-Action-List', template: '#t-Search-Action-List-Template'

  window.searchVM = new Vue
    el: '.t-Search'
    ready: ->
      console.log @urlArray
      self= @

      document.getElementById('t-Modal-Text-Tabpanel-MulUpload-File').addEventListener('change', @T_MulUploadChange, false)
    data:
      tabCount: -1
      tabStatus: 0

      indexcount: 0

      urlArray: []
      urlContent: ''
      urlInput: ''


      # clickDataArray: []
      S_Mul_Array: []

      submitArray: []
      buttonObject: {}

      Modals:
        T_Mul:
          type:'text'
          value: ''
          valuelist: []

    computed:
      currentTab: ->
        # console.log @tabStatus
        return @urlArray[@tabStatus]

    methods:
      addUrlContent: (e) ->
        url = @urlInput
        @tabCount++
        NProgress.start()
        e.preventDefault()
        Meteor.call 'getPhContent', url, 'injectSearch', '', (error, result) =>
          # @urlContent = result
          @urlArray.push
            urlInput: @urlInput,
            urlContent: result,
            clickDataArray: []
          NProgress.done()

        templength=@urlArray.length
        $("#t-Search-Iframe-Tab"+templength).tab 'show'



      whetherText: (type, timbr_clicked) ->
        if (type is 'text') and (timbr_clicked)
          return true
        else
          return false

      whetherCheckbox: (type, checked) ->
        if (type is 'checkbox') and (checked)
          return true
        else
          return false

      whetherRadio: (type, timbr_clicked) ->
        if (type is 'radio') and (timbr_clicked)
          return true
        else
          return false

      whetherSelect: (type, timbr_clicked) ->
        if (type is 'select') and (timbr_clicked)
          return true
        else
          return false

      whetherSubmit: (type, timbr_clicked) ->
        if (type is 'submit') and (timbr_clicked)
          return true
        else
          return false


      onClickExampleBtn: (e) ->
        url = $(e.target).data().url
        @urlInput = url

      # onClickCustomize: (e)->
      #   _button = $(e.target)
      #   @indexcount=_button.data('count')

      #   if @clickDataArray[_button.data('count')].type=='text'
      #     @Modals.T_Mul.value=''
      #     @Modals.T_Mul.valuelist.length=0
      #     $('#t-ModaL-Text').modal()
      #   if @clickDataArray[_button.data('count')].type=='checkbox'
      #     $('#t-ModaL-Checkbox').modal()
      #   if @clickDataArray[_button.data('count')].type=='radio'
      #     @S_Mul_Array.length=0
      #     for key of @clickDataArray[_button.data("count")].valueandlabel
      #       tempvalue = key
      #       templabel = @clickDataArray[_button.data("count")].valueandlabel[key]
      #       @S_Mul_Array.push
      #         value: tempvalue
      #         label: templabel
      #       # console.log @S_Mul_Array
      #     $('#t-ModaL-Radio').modal()
      #     toastr.warning 'Choose this Advance Multiple Result will let out indepent Multiple Results!!'

      #   if @clickDataArray[_button.data('count')].type=='select'
      #     @S_Mul_Array.length=0

      #     for key of @clickDataArray[_button.data("count")].valueandlabel
      #       tempvalue = key
      #       templabel = @clickDataArray[_button.data("count")].valueandlabel[key]
      #       @S_Mul_Array.push
      #         value: tempvalue
      #         label: templabel
      #     $('#t-ModaL-Select').modal()
      #     toastr.warning 'Choose this Advance Multiple Result will let out indepent Multiple Results!!'
      #   return

      # onClickDelete: (e) ->
      #   _button = $(e.target)
      #   @clickDataArray[_button.data('count')].timbr_clicked=false
      #   if @clickDataArray[_button.data('count')].value !=""
      #     @clickDataArray[_button.data('count')].value =""
      #   if @clickDataArray[_button.data('count')].valuelist
      #     delete @clickDataArray[_button.data('count')].valuelist
      #   if @clickDataArray[_button.data('count')].mulmodel =true
      #     @clickDataArray[_button.data('count')].mulmodel=false
      #   return


      # T_MulInputInsert:(type)->
      #   self=@
      #   if type is "AtoZ"
      #     self.Modals.T_Mul.value= "A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z"
      #   if type is "1to9"
      #     self.Modals.T_Mul.value= "1, 2, 3, 4, 5, 6, 7, 8, 9"

      # T_MulInputSubmit: (count)->
      #   self=@
      #   if self.Modals.T_Mul.value
      #     self.Modals.T_Mul.valuelist= self.Modals.T_Mul.value.split ", "
      #   else
      #     toastr.error "Please provide values"
      #   # console.log self.Modals.T_Mul.valuelist

      #   if self.Modals.T_Mul.valuelist.length >=1
      #     @clickDataArray[count].MulMode=true
      #     @clickDataArray[count].Mulvaluelist=self.Modals.T_Mul.valuelist
      #     @clickDataArray[count].value=self.Modals.T_Mul.valuelist[0]
      #     $("#t-ModaL-Text").modal 'toggle'
      #   else
      #     toastr.error "Please provide values"


      # T_MulUploadChange :(e)->
      #   self=@
      #   console.log "file change"
      #   files=document.getElementById 't-Modal-Text-Tabpanel-MulUpload-File'
      #   file=files.files[0]
      #   if file.type.match(/text.*/)
      #     console.log "file success"
      #     reader = new FileReader
      #     reader.onload = (e) ->
      #       self.Modals.T_Mul.value=reader.result
      #       self.Modals.T_Mul.valuelist=self.Modals.T_Mul.value.split ", "

      #     reader.readAsText file
      #   else
      #     toastr.error "This file of type is not support yet"

      # T_MulUploadSubmit :(count)->
      #   self=@
      #   if self.Modals.T_Mul.valuelist.length >=1
      #     @clickDataArray[count].MulMode=true
      #     @clickDataArray[count].Mulvaluelist=self.Modals.T_Mul.valuelist
      #     @clickDataArray[count].value= self.Modals.T_Mul.valuelist[0]
      #     $("#t-ModaL-Text").modal 'toggle'
      #   else
      #     toastr.error "Please provide values"

      # R_dompathUpdate:(obj)->
      #   obj.dompath+= "[value='"+obj.picked+"']"
      #   return obj

      # initializeClickArray : (array) ->
      #   for key in array
      #     if key.type is 'submit'
      #       index=array.indexOf(key)
      #       array.splice(index,1)
      #   return array



      openNewTabFromChildren : (dompath)->
        @urlArray[@tabStatus].clickDataArray.push
          type: 'submit'
          dompath: dompath
          timbr_clicked: true
        @openNewTabFromPhantom(dompath)

      openNewTabFromPhantom: (dompath) ->
        tempSubmitArray = []
        tempSortedArray = []
        for key in @urlArray[@tabStatus].clickDataArray
          if key.type is 'checkbox' and key.checked is true
            tempSubmitArray.push key
          else if key.type is 'text' and key.timbr_clicked is true
            tempSubmitArray.push key
          else if key.type is 'radio' and key.timbr_clicked is true
            key = @R_dompathUpdate(key)
            tempSubmitArray.push key
          else if key.type is 'select' and key.timbr_clicked is true
            tempSubmitArray.push key
          else if key.type is 'submit'
            if key.dompath is dompath
              tempSubmitArray.push key
          else

        tempSortedArray = tempSubmitArray.sort (a , b) ->
          a.timbr_clickedcount - b.timbr_clickedcount
        NProgress.start()
        console.log tempSortedArray
        Meteor.call 'getSearchContent', @urlInput, tempSortedArray, 'injectSearch', (error, result) =>
          @urlArray.push
            urlInput: result.url
            urlContent: result.html
            clickDataArray: []
            actionArray: tempSortedArray
          NProgress.done()



      changeTabStatus:(number)->
        @tabStatus= number

      synchronousDatafromChildren : (object)->
        self =@
        self.urlArray[self.tabStatus].clickDataArray=object
        # @enableTabs()

      # submitTest:()->
      #   for key in @clickDataArray
      #     if key.timbr_clicked is true
      #       if key.type is 'radio'
      #         key=@R_dompathUpdate(key)
      #       @submitArray.push key

      #   @buttonObject.type="button"
      #   @buttonObject.timbr_clickedcount=999
      #   @submitArray.push @buttonObject

      #   sortedArray=[]
      #   sortedArray=@submitArray.sort (a, b) ->
      #     a.timbr_clickedcount - b.timbr_clickedcount
      #   console.log sortedArray

      #   Meteor.call 'getSearchContent', @urlInput, sortedArray, 'injectSearch', (error, result) =>
      #     @urlContent = result.html
      #     searchViewJson =
      #       urlContent: result.html
      #       urlLoaded: result.url
      #     Router.go 'resultView'
      #     Meteor.setTimeout ->
      #       resultVM?.setUrlContentFromSearch searchViewJson
      #     , 0

      # enableTabs: ()->
        # if $("#t-Search-Tab-Step2").hasClass("disabledTab")
        #   $("#t-Search-Tab-Step2").removeClass("disabled")
        #   $("#t-Search-Tab-Step2").removeClass("disabledTab")
        #   $("#t-Search-Main-Panel a[href='#t-Search-Input-Element-Collect']").tab('show')
        #   toastr.success 'Now You just click and input anything you want to search as usual in right page!'

        # if $("#t-Search-Tab-Step3").hasClass("disabledTab")
        #   $("#t-Search-Tab-Step3").removeClass("disabled")
          # $("#t-Search-Tab-Step3").removeClass("disabledTab")

      # submitReady: ()->
      #   @UrlContent= "<h1>Please wait......</h1>"
      #   toastr.success "Please wait!"
      #   $("#t-Search-Main-Panel a[href='#t-Search-Form-Submit']").tab('show')
      #   $("#submitTest").click()
