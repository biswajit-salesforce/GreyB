trigger Competitions on Competition__c (before insert) {
    
    if(CompetitionController.runOnce == false) return;
    CompetitionController.runOnce = false;

    Competition__c newComp = Trigger.new[0];
    Double score = newComp.Score__c; 
    
    List<Competition__c> previous = [SELECT Id, Name, Rank__c, Score__c 
                                    FROM Competition__c 
                                    WHERE Score__c < :score 
                                    ORDER BY Score__c DESC];

    List<Competition__c> total = [SELECT Id, Name, Rank__c, Score__c 
                                    FROM Competition__c 
                                    ORDER BY Score__c DESC];

    Integer size = previous.size();

    if(size == 0){
        newComp.Rank__c = (total.size() == 0) ? 1 : total[ total.size() - 1 ].Rank__c + 1;
        return;
    }else{
        newComp.Rank__c = previous[0].Rank__c;
    }

    for(Integer i = 0; i < size; i ++){
        previous[i].Rank__c = previous[i].Rank__c + 1;
    }
    update previous;
    
}