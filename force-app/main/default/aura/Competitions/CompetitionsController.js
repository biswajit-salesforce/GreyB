({
    submit : function(component, event, helper) {
        var arr = component.find("collect");
        var allValid = true;
        var competition = {};
        for(var i = 0; i< arr.length; i++){
            var isValid = arr[i].checkValidity();
            if(!isValid){
                arr[i].reportValidity();
                allValid = allValid && isValid;
            }
            competition[ arr[i].get("v.name") ] = arr[i].get("v.value");
        }
        console.log('allValid', JSON.stringify(allValid));
        console.log('competition', JSON.stringify(competition));
        if(!allValid) return;
        var action = component.get("c.addingNewScore");
        action.setParams({"competition": JSON.stringify(competition)});
        action.setCallback(this, function(response){
            var status = response.getState();
            
            var message = {
                "type": 'success',
                "title": (message === 'success'),
                "message": "The record has been updated successfully."
            };

            if(status !== 'SUCCESS'){
                message["type"] = 'error';
                message["title"] = 'Error!';
                message["message"] = 'Failed to save the record';
                console.log(JSON.stringify(response.getError()[0].message));
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams(message);
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    }
})

/**
 * ({
    handleSubmit : function(component, event, helper) {
        console.log('11');
        component.find('recordEditForm').submit();
    },

    handleSuccess: function(component, event, helper) {
        var message = {
            "type": 'success',
            "title": 'Success!',
            "message": "The record has been updated successfully."
        };
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams(message);
            toastEvent.fire();
    },

    handleError: function(component, event, helper) {
        var message = {
            "type": 'error',
            "title":'Error!',
            "message": "Error occurred"
        };
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams(message);
            toastEvent.fire();
    }
})
 */