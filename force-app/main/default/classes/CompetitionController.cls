public with sharing class CompetitionController {
    public CompetitionController(){

    }
    public static Boolean runOnce = true;
    @AuraEnabled
    public static void addingNewScore(String competition){
        try {

            Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(competition);
            Competition__c c = new Competition__c();
            c.Name = (String) obj.get('Name');
            c.Score__c = Double.valueOf( obj.get('Score__c') );
            insert c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
