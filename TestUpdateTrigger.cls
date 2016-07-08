@isTest
private class TestUpdateTrigger {
        
    @TestSetup private static void CreateTestData()
    {
        List<Hero__c> heroes = new List<Hero__c>();
                
        for (Integer i = 0; i < 50; i++)
        {
            Hero__c newHero = new Hero__c();
            newHero.Name = 'Test' + i;
            newHero.Race__c = 'Human';
            newHero.Health_Points__c = 100;
            newHero.Dexterity__c = 30;
            newHero.Accuracy__c = 50;
            newHero.Max_Dmg__c = 50;
            newHero.Min_Dmg__c = 40;
            newHero.Wins__c = Math.round(Math.floor(Math.random()*i));
            heroes.add(newHero);
        }        
        insert heroes;
    }
    
    @isTest private static void TriggerTest()
    {
        Integer minwins = 0;
        Integer maxwins = 0;
        List<Hero__c> heroes = [SELECT Id, Name, Wins__c FROM Hero__c LIMIT 1];       
        heroes.get(0).Wins__c ++;
        update heroes;
        List<Hero__c> sortedList = [SELECT Wins__c, Win_Rate__c FROM Hero__c ORDER BY Win_Rate__c];
        
         for (Hero__c item: sortedList)
        {
            if(item.Wins__c > maxwins)
            {
                maxwins = Integer.valueOf(item.Wins__c);
            }
            if(item.Wins__c < minwins)
            {
                minwins = Integer.valueOf(item.Wins__c);
            }
        }
        
        System.assertEquals(minwins, sortedList.get(sortedList.size()-1).Wins__c);
        System.assertEquals(maxwins, sortedList.get(0).Wins__c);
       
    }
}