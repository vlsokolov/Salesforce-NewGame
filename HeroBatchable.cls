global class HeroBatchable implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, Name FROM Hero__c LIMIT 10]);
    }
    
    global void execute(Database.BatchableContext BC, List<Object> scope)
    {
        List<Hero__c> heroes = new List<Hero__c>();
        for(Hero__c item :(List<Hero__c>) scope)
        {
            item.Stamina__c = 100;
            heroes.add(item);
        }
        update heroes;
    }
    
    global void finish(Database.BatchableContext info){    
   }


}