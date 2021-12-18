trigger Competitions on Competition__c (before insert) {
    if(trigger.isInsert){
    if(CompetitionController.runOnce == false) return;
    CompetitionController.runOnce = false;
    List<Competition__c> toUpdate = new List<Competition__c>();
    Competition__c newComp = Trigger.new[0];
    Double score = newComp.Score__c; 

    List<Competition__c> previousComp = [SELECT Id, Name, Rank__c, Score__c 
                                    FROM Competition__c 
                                    ORDER BY Rank__c ASC];

    Integer size = previousComp.size();

    if(size == 0){
        newComp.Rank__c = 1;
        return;
    }
    Boolean newRankSet = false;
    for(Integer i = 0; i < size; i ++){
        if(score == previousComp[i].Score__c){
            newComp.Rank__c = previousComp[i].Rank__c;
            newRankSet = true;
            break;
        }
        if( (score > previousComp[i].Score__c) && ( newRankSet == false) ){
            newComp.Rank__c = previousComp[i].Rank__c;
            newRankSet = true;
        }
        if(newRankSet){
            previousComp[i].Rank__c = previousComp[i].Rank__c + 1;
            toUpdate.add(previousComp[i]);
        }
    }
    if(!newRankSet)
    newComp.Rank__c = previousComp[size - 1].Rank__c + 1;

    if(toUpdate.size() > 0)
    update toUpdate;
    
}