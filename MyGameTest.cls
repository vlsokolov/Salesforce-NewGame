/**
 * This test class was created to test behavior of all NewGameController class methods
 */

@isTest
private class MyGameTest {
           
    @TestSetup private static void CreateTestData()
    {   
        List<Hero__c> listHero = new List<Hero__c>();
        Hero__c testHero = new Hero__c();
        testHero.Name = 'Wolf';
        testHero.Race__c = 'Ork';
        testHero.Health_Points__c = 1000;
        testHero.Accuracy__c = 100;
        testHero.Dexterity__c = 0;
        testHero.Min_Dmg__c = 20;
        testHero.Max_Dmg__c = 50;
        testHero.Block_Time__c = datetime.now().addDays(1);
        testHero.Image_URL__c = 'https://s-media-cache-ak0.pinimg.com/236x/5a/5e/5a/5a5e5af1f3117407341623601720b513.jpg';
        
        Hero__c testHero1 = new Hero__c();
        testHero1.Name = 'Bear';
        testHero1.Race__c = 'Ork';
        testHero1.Health_Points__c = 10;
        testHero1.Accuracy__c = 100;
        testHero1.Dexterity__c = 0;
        testHero1.Min_Dmg__c = 20;
        testHero1.Max_Dmg__c = 50;
        testHero1.Block_Time__c = datetime.now().addDays(-2);
        testHero1.Image_URL__c = 'https://s-media-cache-ak0.pinimg.com/236x/5a/5e/5a/5a5e5af1f3117407341623601720b513.jpg';
       
        listHero.add(testHero);
        listHero.add(testHero1);
        
        insert listHero;            
    }    
    
    @isTest private static void TestWrapperClass()
    {
       NewGameController testSample = new NewGameController();
       NewGameController.HeroWrapp wrapp = new NewGameController.HeroWrapp();
       
       testSample.SelectFromDatabase();
       wrapp = testSample.wrappList.get(0); 
       System.assertEquals(true, wrapp.isDisabled);
       wrapp = testSample.wrappList.get(1); 
       System.assertEquals(null, wrapp.isDisabled); 
    }

    @isTest private static void TestSelectFighter()
    {
        NewGameController testSample = new NewGameController();
        NewGameController.HeroWrapp wrapp = new NewGameController.HeroWrapp();
        
        testSample.SelectFromDatabase();
        wrapp = testSample.wrappList.get(0); 
        wrapp.isSelected = true;
        testSample.wrappList.add(wrapp);
        testSample.FighterSelection();
        System.assertEquals('Wolf', testSample.first.name);
    }
    
    @isTest private static void TestCreateNewFighterFalseCreation()
    {
         NewGameController testSample = new NewGameController();
         testSample.ShowCreationPane();
         System.assertEquals(true, testSample.ShowCreationPanel);
        
        testSample.SelectRace = 'asdas';
        testSample.CreateNewFighter();
        List<Hero__c> testHeroes = new List<Hero__c>([SELECT Id,Name FROM HERO__c WHERE Race__c =: testSample.SelectRace]);
        
        System.assertEquals(0, testHeroes.size());
    }
    
    @isTest private static void TestCreateNewFighterTrueCreationWithDifferentRaces()
    {
        NewGameController testSample = new NewGameController();
        Hero__c testHeroes = new Hero__c();
        
        testSample.SelectRace = 'Dwarf';
        testSample.CreatingHeroName = 'Rat';
        testSample.CreateNewFighter();
        testHeroes = [SELECT Id,Name,Race__c FROM HERO__c WHERE Race__c =: testSample.SelectRace AND Name =: testSample.CreatingHeroName];
        System.assertEquals(testSample.SelectRace, testHeroes.Race__c);
        
        testSample.SelectRace = 'Human';
        testSample.CreatingHeroName = 'Cat';
        testSample.CreateNewFighter();
        testHeroes = [SELECT Id,Name,Race__c FROM HERO__c WHERE Race__c =: testSample.SelectRace AND Name =: testSample.CreatingHeroName];
        System.assertEquals(testSample.SelectRace, testHeroes.Race__c);
        
        testSample.SelectRace = 'Ork';
        testSample.CreatingHeroName = 'Mouse';
        testSample.CreateNewFighter();
        testHeroes = [SELECT Id,Name,Race__c FROM HERO__c WHERE Race__c =: testSample.SelectRace AND Name =: testSample.CreatingHeroName];
        System.assertEquals(testSample.SelectRace, testHeroes.Race__c);
        
        testSample.SelectRace = 'Elven';
        testSample.CreatingHeroName = 'Fish';
        testSample.CreateNewFighter();
        testHeroes = [SELECT Id,Name,Race__c FROM HERO__c WHERE Race__c =: testSample.SelectRace AND Name =: testSample.CreatingHeroName];
        System.assertEquals(testSample.SelectRace, testHeroes.Race__c);       
    }
    
    @isTest private static void TestSelectHitAndBlockZonesAndTheirRandomSelection()
    {
        NewGameController testSample = new NewGameController();
        List<Integer> selectValue = new List<Integer>{0,1,2,3};
            
        while(selectValue.size() > 0)
        {
           Integer place = Math.round((Math.floor(Math.random() * 3.5)));
           for (integer i = 0; i < selectvalue.size(); i++) 
           {
               if (selectvalue.get(i) == place)
               {
                   selectValue.remove(i);
               }
           }
        }
        
        System.assertEquals('Head', testSample.getItems().get(0).getValue());
    }
    
    @isTest private static void TestFightCalculationFirstWin()
    {
        NewGameController testSample = new NewGameController();
        
        List<Hero__c> SelectedHero = [SELECT id, Name, Race__c, Health_Points__c, Min_Dmg__c, Max_Dmg__c, Accuracy__c, Dexterity__c, Image_URL__c
                  					   FROM Hero__c];
        
        String zone = 'head';
        testSample.hitPlace = zone;
        testSample.BlockPlace = zone;
        testSample.first = new Hero(SelectedHero.get(0).name, SelectedHero.get(0).Race__c, Integer.valueOf(SelectedHero.get(0).Health_Points__c),
                        Integer.valueOf(SelectedHero.get(0).Min_Dmg__c), Integer.valueOf(SelectedHero.get(0).Max_Dmg__c),
                        Integer.valueOf(SelectedHero.get(0).Accuracy__c), Integer.valueOf(SelectedHero.get(0).Dexterity__c),
                        SelectedHero.get(0).Image_URL__c);
        testSample.second = new Hero(SelectedHero.get(1).name, SelectedHero.get(1).Race__c, Integer.valueOf(SelectedHero.get(1).Health_Points__c),
                        Integer.valueOf(SelectedHero.get(1).Min_Dmg__c), Integer.valueOf(SelectedHero.get(1).Max_Dmg__c),
                        Integer.valueOf(SelectedHero.get(1).Accuracy__c), Integer.valueOf(SelectedHero.get(1).Dexterity__c),
                        SelectedHero.get(1).Image_URL__c); 
        testSample.roundNumber = 1;
        testSample.FightCalculation();
        
        System.assertEquals(0, testSample.second.getHP());
        System.assertEquals(testSample.fightLogMessage, testSample.first.name + ' Win!');
    }
    
    @isTest private static void TestFightCalculationSecondWin()
    {
        NewGameController testSample = new NewGameController();
        
        List<Hero__c> SelectedHeroes = [SELECT id, Name, Race__c, Health_Points__c, Min_Dmg__c, Max_Dmg__c, Accuracy__c, Dexterity__c, Image_URL__c
                  					   FROM Hero__c];
        
        String zone = 'Legs';
        testSample.hitPlace = zone;
        testSample.BlockPlace = zone;
        testSample.first = new Hero(SelectedHeroes.get(0).name, SelectedHeroes.get(0).Race__c, Integer.valueOf(SelectedHeroes.get(1).Health_Points__c),
                        Integer.valueOf(SelectedHeroes.get(0).Min_Dmg__c), Integer.valueOf(SelectedHeroes.get(0).Max_Dmg__c),
                        Integer.valueOf(SelectedHeroes.get(0).Accuracy__c), Integer.valueOf(SelectedHeroes.get(0).Dexterity__c),
                        SelectedHeroes.get(0).Image_URL__c);
        testSample.second = new Hero(SelectedHeroes.get(1).name, SelectedHeroes.get(1).Race__c, Integer.valueOf(SelectedHeroes.get(0).Health_Points__c),
                        Integer.valueOf(SelectedHeroes.get(1).Min_Dmg__c), Integer.valueOf(SelectedHeroes.get(1).Max_Dmg__c),
                        Integer.valueOf(SelectedHeroes.get(1).Accuracy__c), Integer.valueOf(SelectedHeroes.get(1).Dexterity__c),
                        SelectedHeroes.get(1).Image_URL__c); 
        testSample.roundNumber = 1;
        testSample.SelectedHero = selectedheroes.get(0);
        testSample.FightCalculation();
        
        System.assertEquals(0, testSample.first.getHP());
        System.assertEquals(testSample.fightLogMessage, testSample.second.name + ' Win!');
    }
}