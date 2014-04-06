/*
 * INTER-Mediator Ver.@@@@2@@@@ Released @@@@1@@@@
 *
 *   by Masayuki Nii  msyk@msyk.net Copyright (c) 2014 Masayuki Nii, All rights reserved.
 *
 *   This project started at the end of 2009.
 *   INTER-Mediator is supplied under MIT License.
 */

IMLibLocalContext = {
    contextName: "_",
    store: {},
    binding: {},

    clearAll: function () {
        this.store = {};
    },

    setValue: function (key, value) {
        var i, hasUpdated, refIds, node;
        hasUpdated = false;
        if (key != undefined && key != null) {
            if (value === undefined || value === null) {
                delete this.store[key];
            } else {
                this.store[key] = value;
                hasUpdated = true;
                refIds = this.binding[key];
                if (refIds) {
                    for (i = 0; i < refIds.length; i++) {
                        node = document.getElementById(refIds[i]);
                        IMLibElement.setValueToIMNode(node, "", value, true);
                    }
                }
            }
        }
        if (hasUpdated) {
            this.archive();
        }
    },

    getValue: function (key) {
        var value = this.store[key];
        return value === undefined ? null : value;
    },

    archive: function () {
        var jsonString;
        INTERMediatorOnPage.removeCookie('_im_localcontext');
        if (INTERMediator.isIE && INTERMediator.ieVersion < 9) {
            this.store._im_additionalCondition = INTERMediator.additionalCondition;
            this.store._im_additionalSortKey = INTERMediator.additionalSortKey;
            this.store._im_startFrom = INTERMediator.startFrom;
            /*
             IE8 issue: "" string is modified as "null" on JSON stringify.
             http://blogs.msdn.com/b/jscript/archive/2009/06/23/serializing-the-value-of-empty-dom-elements-using-native-json-in-ie8.aspx
             */
            jsonString = JSON.stringify(this.store, function(k, v) { return v === "" ? "" : v });
        } else {
            jsonString = JSON.stringify(this.store);
        }
        INTERMediatorOnPage.setCookieWorker('_im_localcontext', jsonString, false, 300000);
    },

    unarchive: function () {
        var persistentData = INTERMediatorOnPage.getCookie('_im_localcontext');
        if (persistentData.length > 0) {
            this.store = JSON.parse(persistentData);
            if (INTERMediator.isIE && INTERMediator.ieVersion < 9) {
                if (this.store._im_additionalCondition) {
                    INTERMediator.additionalCondition = this.store._im_additionalCondition;
                }
                if (this.store._im_additionalSortKey) {
                    INTERMediator.additionalSortKey = this.store._im_additionalSortKey;
                }
                if (this.store._im_startFrom) {
                    INTERMediator.startFrom = this.store._im_startFrom;
                }
            }
        }
    },

    binding: function (node) {
        var linkInfos, nodeInfo, idValue, i, value;
        if (node.nodeType != 1) {
            return;
        }
        linkInfos = INTERMediatorLib.getLinkedElementInfo(node);
        for (i = 0; i < linkInfos.length; i++) {
            nodeInfo = INTERMediatorLib.getNodeInfoArray(linkInfos[i]);
            if (nodeInfo.table == this.contextName) {
                if (!node.id) {
                    node.id = nextIdValue();
                }
                idValue = node.id;
                if (!this.binding[nodeInfo.field]) {
                    this.binding[nodeInfo.field] = [];
                }
                this.binding[nodeInfo.field].push(idValue);
                var nodeId = idValue;
                var self = this;
                INTERMediatorLib.addEvent(node, 'change', function () {
                    self.update(nodeId);
                    //    INTERMediator.recalculation();
                });

                value = this.store[nodeInfo.field];
                IMLibElement.setValueToIMNode(node, nodeInfo.target, value, true);
            }
        }

        function nextIdValue() {
            INTERMediator.linkedElmCounter++;
            return currentIdValue();
        }

        function currentIdValue() {
            return 'IM' + INTERMediator.currentEncNumber + '-' + INTERMediator.linkedElmCounter;
        }

    },

    update: function (idValue) {
        var node, nodeValue, linkInfos, nodeInfo, i;
        node = document.getElementById(idValue);
        nodeValue = IMLibElement.getValueFromIMNode(node);
        linkInfos = INTERMediatorLib.getLinkedElementInfo(node);
        for (i = 0; i < linkInfos.length; i++) {
            nodeInfo = INTERMediatorLib.getNodeInfoArray(linkInfos[i]);
            if (nodeInfo.table == this.contextName) {
                this.setValue(nodeInfo.field, nodeValue);
            }
        }
    },

    bindingDescendant: function (rootNode) {
        var self = this;
        seek(rootNode);

        function seek(node) {
            var children, i;
            if (node.nodeType === 1) { // Work for an element
                try {
                    self.binding(node);
                    children = node.childNodes; // Check all child nodes.
                    if (children) {
                        for (i = 0; i < children.length; i++) {
                            seek(children[i]);
                        }
                    }
                } catch (ex) {
                    if (ex == "_im_requath_request_") {
                        throw ex;
                    } else {
                        INTERMediator.setErrorMessage(ex, "EXCEPTION-31");
                    }
                }
            }
        }
    }
};

IMLibKeyEventDispatch = {
    dispatchTable: {},

    clearAll: function () {
        this.dispatchTable = {};
    },

    setExecute: function(idValue, charCode, exec)   {
        if (idValue && charCode)    {
            if (! this.dispatchTable[idValue])  {
                this.dispatchTable[idValue] = {};
            }
            this.dispatchTable[idValue][charCode] = exec;
        }
    }
};
INTERMediatorLib.addEvent(document, "keydown", function(e){
    var event = e ? e : window.event;
    if (event.charCode) {
        var charCode = event.charCode;
    } else {
        var charCode = event.keyCode;
    }
    if (! event)    {
        return;
    }
    var target = event.target;
    if (! target)    {
        target = event.srcElement;
        if (! target)    {
            return;
        }
    }
    var idValue = target.id;
    if (! idValue)   {
        return;
    }
    if (! IMLibKeyEventDispatch.dispatchTable[idValue]){
        return;
    }
    var executable = IMLibKeyEventDispatch.dispatchTable[idValue][charCode];
    if (! executable)    {
        return;
    }
    executable(event);
});

IMLibMouseEventDispatch = {
    dispatchTable: {},

    clearAll: function () {
        this.dispatchTable = {};
    },

    setExecute: function(idValue, exec)   {
        if (idValue)    {
            this.dispatchTable[idValue] = exec;
        }
    }
};

INTERMediatorLib.addEvent(document, "click", function(e)  {
    var event = e ? e : window.event;
    if (! event)    {
        return;
    }
    var target = event.target;
    if (! target)    {
        target = event.srcElement;
        if (! target)    {
            return;
        }
    }
    var idValue = target.id;
    if (! idValue)   {
        return;
    }
    var executable = IMLibMouseEventDispatch.dispatchTable[idValue];
    if (! executable)    {
        return;
    }
    executable(event);
});