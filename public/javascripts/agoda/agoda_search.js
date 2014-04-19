//
//	Copyright Agoda 2007, all rights reserved!
//  Author: Thalwin Hulsebos
//  Version: 1.0.0beta
//  Date: 15-May-2007
//	------------------------------------------------

// Script to detect the URL to be used for all scripts
function getScrURL() {
    var objScripts = document.getElementsByTagName("SCRIPT");
    var retVal = "";
    for (i = 0; i < objScripts.length; i++) {
        var tstval = new String(objScripts[i].src.toLowerCase());
        if (tstval.indexOf("agoda_search.js") != -1) {
            retVal = tstval.substring(0, tstval.indexOf("/affiliates/js/agoda_search.js"));
        }
    }
    return retVal;
}

var agoda_url = "http://ajaxsearch.partners.agoda.com";
var agoda_posturl = agoda_url + "/pages/agoda/default/waitpage.aspx";
var agoda_searchscript = "/affiliates/getSearchBox.aspx";
var agoda_jscalendarscript = "/affiliates/js/agoda_calendar.js";
var agoda_jslangscript = "/affiliates/js/agoda_langjs.aspx";
var agoda_jsmainsearchscript = "/affiliates/js/agoda_mainsearch.js";
var agoda_cityscript = "/affiliates/ajax/ajaxGetCities.aspx";
var agoda_hotelscript = "/affiliates/ajax/ajaxGetHotels.aspx";
var agoda_defaultstyle = "/affiliates/styles/search_style1.css";
var agoda_calstyle = "/affiliates/styles/calendar.css";
var form_pat = /<form[\s\S]*?\/?>[\n\r]?/gi;
var body_pat = /<body[\s\S]*?\/?>[\n\r]?/gi;
var _newwindow = false;

function SrchObject() {
    var _cid;
    var _objId;
    var _langid = '';
    var _displCal = false;
    var parArr = new Array();
    //var colArr = new Array();
    var styleArr = new Array();
    var boxType;
    this.clientID = _clientID;
    this.setLangID = _setLangID;
    this.setNewWindow = _setNewWindow;
    this.displaySearch = _displaySearch;
    this.callback_displaySearch = _callback_displaySearch;
    this.addParam = _addParam;
    this.clear = _clear;
    this.clearParam = _clearParam;
    this.useStyleSheet = _useStyleSheet;
    this.useURL = _useURL;
    this.displCalendar = _displCalendar;
    this.setTarget = _setTarget;
    this.setColor = _setColor;
    this.setStyle = _setStyle;
    this.post2URL = _post2URL;
    this.refresh = _refresh;
    //this.displayiFrame=_displayiFrame;

    function _clearParam() {
        parArr.length = 0;
        _displCal = false;
    }
    function _clear() {
        var objLang = document.getElementById('agoda_langscript');
        parArr.length = 0;
        styleArr.length = 0;
        _displCal = false;
        _langid = '';
    }
    function _clientID(cidval) {
        _cid = cidval;
    }
    function _setLangID(langid) {
        _langid = langid;
    }
    function _setNewWindow(newwindow) {
        _newwindow = newwindow;
    }
    function _displCalendar() {
        _displCal = true;
        _addParam("usecal", "true");
    }
    function _useURL(urlval) {
        agoda_url = urlval;
    }
    function _post2URL(urlval) {
        agoda_posturl = urlval;
    }

    function _useStyleSheet(cssstyle) {
        if (!document.getElementById('agoda_usedstyle')) {

            var objHead = document.getElementsByTagName('head');
            objCSS = document.createElement('link');
            objCSS.rel = 'stylesheet';
            objCSS.href = cssstyle;
            objCSS.type = 'text/css';
            objCSS.id = "agoda_usedstyle";
            objHead[0].appendChild(objCSS);
        } else {
            objCSS.href = cssstyle;
        }
        //_addParam("style",cssstyle);
    }
    function _setStyle(objid, attr, value) {
        styleArr[styleArr.length++] = new styleItem(objid, attr, value);
    }
    function styleItem(objid, attr, value) {
        this.objid = objid;
        this.attr = attr;
        this.value = value;
    }
    function _setColor(objtype, colorCode) {
        switch (objtype.toLowerCase()) {
            case "text":
                _setStyle("agoda_country_label", "color", colorCode);
                _setStyle("agoda_city_label", "color", colorCode);
                _setStyle("agoda_hotel_label", "color", colorCode);
                _setStyle("agoda_checkin_label", "color", colorCode);
                _setStyle("agoda_checkout_label", "color", colorCode);
                _setStyle("agoda_room_label", "color", colorCode);
                _setStyle("agoda_adult_label", "color", colorCode);
                _setStyle("agoda_children_label", "color", colorCode);
                //_addParam("text",colorCode);
                break;
            case "bg":
                _setStyle("agoda_searchbox_wrapper", "backgroundColor", colorCode);
                //_addParam("bg",colorCode);
                break;
            case "border":
                _setStyle("agoda_searchbox_wrapper", "border", "solid 1px " + colorCode);
                //_addParam("border",colorCode);
                break;
            case "button_text":
                _setStyle("agoda_btnSubmit", "color", colorCode);
                //_addParam("button_text",colorCode);
                break;
            case "button_bg":
                _setStyle("agoda_btnSubmit", "backgroundColor", colorCode);
                //_addParam("button_bg",colorCode);
                break;
            case "button_border":
                _setStyle("agoda_btnSubmit", "border", "solid 1px " + colorCode);
                //_addParam("button_border",colorCode);
                break;
        }
    }
    function _addParam(parName, parValue) {
        if (parName == "usecal" && parValue == "true")
            _displCal = true;
        if (parName == "post2URL" && parValue != "")
            _post2URL(parValue);

        parArr[parArr.length++] = new parItem(parName, parValue);
    }
    function parItem(parName, parValue) {
        this.name = parName;
        this.value = parValue;
    }

    function _setTarget(objid) {
        _objId = objid;
    }

    function _refresh() {
        var obj = document.getElementById(_objId);
        obj.innerHTML = "<img src='" + agoda_url + "/affiliates/images/ajaxloader.gif'>";
        _displaySearch(_objId);
    }

    function _displaySearch(objid) {        
        _objId = objid
        var obj = document.getElementById(objid);
        // Validation of required object and variables
        if (!obj) {
            alert("Required Element '" + objid + "' is missing!");
            return false;
        }
        if (!_cid) {
            alert("Required ClientID is missing!");
            return false;
        }
        
        // Registration of required scripts and stylesheets
        var TimeStamp = getTimeStamp();
        var old = document.getElementById("agoda_langscript");
        if (old) {
            var objHead = document.getElementsByTagName('head');
            objHead[0].removeChild(old);
        }

        if (!document.getElementById('agoda_langscript')) {
            var objHead = document.getElementsByTagName('head');
            jsLanguage = document.createElement("script");
            jsLanguage.setAttribute("language", "javascript");
            jsLanguage.setAttribute("type", "text/javascript");
            jsLanguage.setAttribute("charset", "UTF-8");
            jsLanguage.setAttribute("src", agoda_url + agoda_jslangscript + "?langid=" + _langid + "&ts=" + TimeStamp);
            jsLanguage.id = "agoda_langscript";
            objHead[0].appendChild(jsLanguage);
        } else {            
            document.getElementById('agoda_langscript').src = agoda_url + agoda_jslangscript + "?langid=" + _langid + "&ts=" + TimeStamp;
        }
        if (!document.getElementById('agoda_mainsearchscript')) {
            var objHead = document.getElementsByTagName('head');
            jsMain = document.createElement("script");
            jsMain.setAttribute("language", "javascript");
            jsMain.setAttribute("type", "text/javascript");
            jsMain.setAttribute("src", agoda_url + agoda_jsmainsearchscript);
            jsMain.id = "agoda_mainsearchscript";
            objHead[0].appendChild(jsMain);
        }
        // Make sure that a style is being used
        if (!document.getElementById('agoda_usedstyle')) {
            var objHead = document.getElementsByTagName('head');
            objCSS = document.createElement('link');
            objCSS.rel = 'stylesheet';
            objCSS.href = agoda_url + agoda_defaultstyle;
            objCSS.type = 'text/css';
            objCSS.id = "agoda_usedstyle";
            objHead[0].appendChild(objCSS);
        }
        if (_displCal) {            
            if (!document.getElementById('agoda_calstyle')) {            
                var objHead = document.getElementsByTagName('head');
                objCalCSS = document.createElement('link');
                objCalCSS.rel = 'stylesheet';
                objCalCSS.href = agoda_url + agoda_calstyle;
                objCalCSS.type = 'text/css';
                objCalCSS.id = "agoda_calstyle";
                objHead[0].appendChild(objCalCSS);
            }            
            if (!document.getElementById('agoda_calendarscript')) {
                var objHead = document.getElementsByTagName('head');
                jsCalendar = document.createElement("script");
                jsCalendar.setAttribute("language", "javascript");
                jsCalendar.setAttribute("type", "text/javascript");
                jsCalendar.setAttribute("charset", "UTF-8");
                jsCalendar.setAttribute("src", agoda_url + agoda_jscalendarscript);
                jsCalendar.id = "agoda_calendarscript";
                objHead[0].appendChild(jsCalendar);                
            }           
        }
        
        var url = agoda_url + agoda_searchscript + "?cid=" + _cid + "&langid=" + _langid + getParameters() + "&ts=" + TimeStamp;
        
        var old = document.getElementById("agoda_boxscript");
        if (old) {
            document.body.removeChild(old);
        }
        
        jsBox = document.createElement("script");
        jsBox.setAttribute("language", "javascript");
        jsBox.setAttribute("type", "text/javascript");
        jsBox.setAttribute("charset", "UTF-8");
        jsBox.setAttribute("src", url);
        jsBox.id = "agoda_boxscript";
        document.body.appendChild(jsBox);
    }
    
    function _callback_displaySearch() {
        var obj = document.getElementById(_objId);
        var retval = unescape(srcboxContent);
        //alert("callbackDone:"+retval);
        obj.innerHTML = retval;
        overwriteStyles();
        SetDateValues();
    }

    function getParameters() {
        var retval = "";
        for (i = 0; i < parArr.length; i++) {
            retval += "&" + parArr[i].name + "=" + escape(parArr[i].value);
        }
        return retval;
    }

    function overwriteStyles() {
        for (i = 0; i < styleArr.length; i++) {
            var obj = document.getElementById(styleArr[i].objid);
            if (obj) {
                var evVal = "document.getElementById(styleArr[i].objid).style." + styleArr[i].attr + "='" + styleArr[i].value + "'";
                eval(evVal);
            } else {
                alert("Element " + styleArr[i].objid + " is missing!");
            }
        }
    }
}

function agoda_GetCityList(countryId) {
    var obj = document.getElementById("agoda_city_input");
    var _cid = document.getElementById("agoda_CID").value;
    // Validation on required object and variables
    if (!obj) {
        alert("Required Element 'divCitySelected' is missing!");
        return false;
    }
    if (!countryId) {
        alert("Required countryId is missing!");
        return false;
    }
    var strHTML = "<select name='ddlTemp' class='agoda_city_field' disabled><option value='0'>" + document.getElementById("agoda_txtloading").value + "...</option></select>";
    obj.innerHTML = strHTML;
    document.getElementById("agoda_hotel_input").innerHTML = "<select name='ddlSelectHotel' id='ddlSelectHotel' class='agoda_hotel_field' disabled><option value='0'>" + document.getElementById("agoda_txtselHotel").value + "...</option></select>";

    var TimeStamp = getTimeStamp();
    var url = agoda_url + agoda_cityscript + "?cid=" + _cid + "&countryid=" + countryId + "&ts=" + TimeStamp;

    var old = document.getElementById("agoda_getcityscript");
    if (old) {
        document.body.removeChild(old);
    }
    jsBox = document.createElement("script");
    jsBox.setAttribute("language", "javascript");
    jsBox.setAttribute("type", "text/javascript");
    jsBox.setAttribute("charset", "UTF-8");
    jsBox.setAttribute("src", url);
    jsBox.id = "agoda_getcityscript";
    document.body.appendChild(jsBox);
}

function callBack_City() {
    var obj = document.getElementById("agoda_city_input");
    var retval = unescape(ret_cityList);
    //alert("callBack_City:"+retval);
    obj.innerHTML = retval;
    var tstVal = document.getElementById("ddlSelectCity");
    if (tstVal.value != "0") {
        // load hotellist in case of single hotel
        agoda_GetHotelList(tstVal.value);
    }
}

function agoda_GetHotelList(CityID) {
    var obj = document.getElementById("agoda_hotel_input");
    // Validation on required object and variables
    if (!obj) {
        alert("Required Element 'agoda_hotel_input' is missing!");
        return false;
    }
    if (!CityID) {
        alert("Required CityID is missing!");
        return false;
    }
    var _cid = document.getElementById("agoda_CID").value;
    var countryId = document.getElementById("ddlSelectCountry").value;

    var strHTML = "<select name='ddlSelectHotel' id='ddlSelectHotel' class='agoda_hotel_field' disabled><option value='0'>" + document.getElementById("agoda_txtloading").value + "...</option></select>";
    obj.innerHTML = strHTML;

    var TimeStamp = getTimeStamp();
    var url = agoda_url + agoda_hotelscript + "?cid=" + _cid + "&countryid=" + countryId + "&cityid=" + CityID + "&ts=" + TimeStamp;

    var old = document.getElementById("agoda_gethotelscript");
    if (old) {
        document.body.removeChild(old);
    }
    jsBox = document.createElement("script");
    jsBox.setAttribute("language", "javascript");
    jsBox.setAttribute("type", "text/javascript");
    jsBox.setAttribute("charset", "UTF-8");
    jsBox.setAttribute("src", url);
    jsBox.id = "agoda_gethotelscript";
    document.body.appendChild(jsBox);
}

function callBack_Hotel() {
    var obj = document.getElementById("agoda_hotel_input");
    var retval = unescape(ret_hotelList);
    obj.innerHTML = retval;
}

function agoda_updButtonTxt() {
    var hotel_id = document.getElementById("ddlSelectHotel").value;
    var btn_id = document.getElementById("agoda_btnSubmit");
    if (typeof (btn_id) == "object") {
        if (hotel_id != '0')
            btn_id.value = txtBtnCheckRates;
        else
            btn_id.value = txtBtnFindHotels;
    }
}

function getTimeStamp() {
    var TimeStamp = new Date();
    var dateNow = TimeStamp.getDate() + '';
    var hoursNow = TimeStamp.getHours() + '';
    var minNow = TimeStamp.getMinutes() + '';
    var secNow = TimeStamp.getSeconds() + '';
    var msNow = TimeStamp.getMilliseconds() + '';

    return escape(dateNow + hoursNow + minNow + secNow + msNow);
}

function addEvent(obj, evType, fn) {
    if (obj.addEventListener) {
        obj.addEventListener(evType, fn, false);
        return true;
    } else if (obj.attachEvent) {
        var r = obj.attachEvent("on" + evType, fn);
        return r;
    } else {
        return false;
    }
}