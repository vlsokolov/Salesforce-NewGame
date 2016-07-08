trigger CheckWinRate on Hero__c (before update) {  
       
  if(Trigger.isUpdate)
   {   
       List<Hero__c> updatedHero = new List<Hero__c>();
       Boolean firstupdate = false;
       for (Integer i = 0; i < Trigger.New.size(); i++)
       {
           if (Trigger.New.get(i).Wins__c != Trigger.old.get(i).Wins__c)
           {
              firstupdate = true;
              updatedHero.add(Trigger.New.get(i));
           }
       }
       if (firstupdate)
       {
       List<Hero__c> heroes = [SELECT Id, Name, Wins__c, Win_Rate__c FROM Hero__c];
       List<Hero__c> heroesWithWinRates = new List<Hero__c>();
       List<HeroWrapper> wrappherolist = new List<HeroWrapper>();           
           
       for (Hero__c item: heroes)
       {
           for (Hero__c winner: updatedHero)
           {
          	 if (item.Id == winner.Id)
           		{
               		item.Wins__c = winner.Wins__c;
           		}
           }
           wrappherolist.add(new HeroWrapper(item));
       }
           
       wrappherolist.sort();
       Integer i = 1;   
                
         for (HeroWrapper item: wrappherolist)
         {
             for (Hero__c winner:updatedHero)
             {
          		if (item.id != winner.id)
          		{
				for (Hero__c h:heroes)
                {
                    if (item.Id == h.id)
                    {
                		h.Win_Rate__c = i;
                		heroesWithWinRates.add(h);
                    }
                }    
          } else {
            winner.Win_Rate__c = i;
          }
          i++; 
         }
       } 
      update heroesWithWinRates;
   	}
  }   
}