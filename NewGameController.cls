/*
 * This is my game. This game provide you such functionality:
 * you can select a fighter;
 * you can create your own hero and store it in the database,
 * in creation process you can specify only the Name and the Race of your fighter
 * all another characterization automatically filled depending on the chosen Race.
 * It's prevent you from creation of SUPERHERO:);
 * when the fight begin each round you should manually select the Hit and Block zones;
 * when your Hero win, the programm automatically calculate his new rating.
 * 
 * Have a fun and enjoy this game(I spend a lot of time for it creation:)
 * 
 * @author Vladimir Sokolov
 */

public class NewGameController 
{
    Public Boolean ShowCreationPanel {get; set;}
    Public Boolean ShowFightingPanel {get; set;}
    Public Boolean ShowSelectionPanel {get; set;}
    Public Boolean ShowFightResultPanel {get; set;}
    Public Hero first {get; set;}
    Public Hero second {get; set;}
    Public Hero__c SelectedHero {get; set;}
    Public Hero__c PcFighter {get;set;}
    Public List<Hero__c> heroes{get; set;}
    Public List<HeroWrapp> wrappList {get; set;}
    Public String SelectRace {get; set;}
    Public String CreatingHeroName {get; set;}
    Public String HitPlace {get; set;}
    Public String BlockPlace {get; set;}
    Public String fightLogMessage {get; set;}
    Public Integer roundNumber {get; set;}
        
    /**
     * Create a Wrapper Class for a Hero to view it on the VF Page with ability to select the hero for a fight
     */
     
    public class HeroWrapp
    {
        public String id{get; set;}
        public String Name{get; set;}
        public String Race{get; set;}
        public Boolean isSelected{get; set;}
        public Boolean isDisabled{get; set;}
        public DateTime timeToRelease {get; set;}
    }
    
    /**
     * In this method, we selected all records from Database and create the list of wrapped objects to 
     * their view on the VF Page
     */
    
    public void SelectFromDatabase()
    {
        heroes = [SELECT id, Name, Race__c, Health_Points__c, Min_Dmg__c, Max_Dmg__c, Accuracy__c, 
                  Dexterity__c, Image_URL__c, Block_Time__c, Wins__c, Win_Rate__c, Stamina__c
                  FROM Hero__c ORDER BY Race__c];
        wrappList = new List<HeroWrapp>();
        
        DateTime currentDateTime = datetime.now();
        
        for (Hero__c h: heroes)
        {
            HeroWrapp wrapp = new HeroWrapp();
            wrapp.id = h.id;
            wrapp.name = h.name;
            wrapp.Race = h.Race__c;
            wrapp.isSelected = false;
            if (h.Block_Time__c != null && currentDateTime < h.Block_Time__c)
            {
                wrapp.isDisabled = true;
                wrapp.timeToRelease = h.Block_Time__c;
            }
            if (h.Stamina__c <= 0)
            {
                wrapp.isDisabled = true;                
            }
            wrappList.add(wrapp);
        }
    }
    
    public NewGameController()
    {
        ShowSelectionPanel = true;
        SelectFromDatabase();  
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'You should select only one hero');
        ApexPages.addMessage(myMsg);
    }
        
    /**
     * In this method, we create fighters for a game. First fighter was select by User, second - automatically
     * selected by programm
     */
    
    public void FighterSelection()
    {
      String selectedHeroId;
      Integer countSelections = 0;  
        
      for (HeroWrapp wr: wrappList)
        {
            if (wr.isSelected)
            {
                countSelections ++;
                SelectedHeroId = wr.id;
            }
        }

        if (countSelections == 1)
        {            
		SelectedHero = [SELECT id, Name, Race__c, Health_Points__c, Min_Dmg__c, Max_Dmg__c, Accuracy__c, Dexterity__c, 
                        Image_URL__c, Wins__c, Win_Rate__c, Stamina__c
                  		FROM Hero__c 
                        WHERE id =: selectedHeroId]; 
        
        first = new Hero(SelectedHero.Name, SelectedHero.Race__c, Integer.valueOf(SelectedHero.Health_Points__c),
                        Integer.valueOf(SelectedHero.Min_Dmg__c), Integer.valueOf(SelectedHero.Max_Dmg__c),
                        Integer.valueOf(SelectedHero.Accuracy__c), Integer.valueOf(SelectedHero.Dexterity__c),
                        SelectedHero.Image_URL__c, Integer.valueOf(SelectedHero.Wins__c), Integer.valueOf(SelectedHero.Win_Rate__c));
        
        Integer RandomPCFighter = Math.round(Math.floor(Math.random() * (heroes.size() - 0.5)));

        PcFighter = heroes.get(RandomPcFighter);
        second = new Hero(PcFighter.Name, PcFighter.Race__c, Integer.valueOf(PcFighter.Health_Points__c),
                        Integer.valueOf(PcFighter.Min_Dmg__c), Integer.valueOf(PcFighter.Max_Dmg__c),
                        Integer.valueOf(PcFighter.Accuracy__c), Integer.valueOf(PcFighter.Dexterity__c),
                        PcFighter.Image_URL__c, Integer.valueOf(PcFighter.Wins__c), Integer.valueOf(PcFighter.Win_Rate__c));
        
        ShowFightingPanel = true;
        ShowFightResultPanel = true;
        ShowSelectionPanel = false;
        roundNumber = 1;
        }
    }
    
    public void ShowCreationPane()
    {
        ShowCreationPanel = true;
        ShowSelectionPanel = false;
    }          
    
    /**
     * In this method, we create new fighter and store it in the database
     */
    
    public void CreateNewFighter()
    {
        if ((SelectRace == 'Human') || (SelectRace == 'Ork') || (SelectRace == 'Dwarf') || (SelectRace == 'Elven'))
        {
        Hero__c createdFighter = new Hero__c();
        createdFighter.Name = CreatingHeroName;
        
        if (SelectRace == 'Human')
        {
            createdFighter.Race__c = 'Human';
            createdFighter.Health_Points__c = 700;
            createdFighter.Min_Dmg__c = 40;
            createdFighter.Max_Dmg__c = 50;
            createdFighter.Accuracy__c = 60;
            createdFighter.Dexterity__c = 40;
            createdFighter.Image_URL__c = 'https://s-media-cache-ak0.pinimg.com/236x/5a/5e/5a/5a5e5af1f3117407341623601720b513.jpg';
        }
        if (SelectRace == 'Ork')
        {
            createdFighter.Race__c = 'Ork';
            createdFighter.Health_Points__c = 1000;
            createdFighter.Min_Dmg__c = 30;
            createdFighter.Max_Dmg__c = 100;
            createdFighter.Accuracy__c = 40;
            createdFighter.Dexterity__c = 20;
            createdFighter.Image_URL__c = 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQpT_5jzxE-rFVs5yU23UO9Pki6UZ_lIoSUdyzmVj5qd_FFuEtvfA';
        }
        if (SelectRace == 'Dwarf')
        {
            createdFighter.Race__c = 'Dwarf';
            createdFighter.Health_Points__c = 800;
            createdFighter.Min_Dmg__c = 40;
            createdFighter.Max_Dmg__c = 80;
            createdFighter.Accuracy__c = 50;
            createdFighter.Dexterity__c = 30;
            createdFighter.Image_URL__c = 'http://pre14.deviantart.net/b30c/th/pre/f/2013/146/a/a/dwarven_paladin___algadon_by_seraph777-d66p38y.jpg';
        }
        if (SelectRace == 'Elven')
        {
            createdFighter.Race__c = 'Elven';
            createdFighter.Health_Points__c = 500;
            createdFighter.Min_Dmg__c = 50;
            createdFighter.Max_Dmg__c = 60;
            createdFighter.Accuracy__c = 70;
            createdFighter.Dexterity__c = 45;
            createdFighter.Image_URL__c = 'https://s-media-cache-ak0.pinimg.com/736x/3c/0e/a5/3c0ea5bd7e1ecb183fd6c79b92628713.jpg';
        }
        
       
        ShowCreationPanel = false;
        
            try
            {
               insert createdFighter; 
            }catch (DMLException e)
            {}
        
        SelectFromDatabase();     
        } else 
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter the right Race. Such as: "Human", "Ork", "Dwarf", "Elven"');
          ApexPages.addMessage(myMsg);
        }
    }
    
    /**
     * In this code block we create the list of posible hit and block zones and after user's select use it
     * in the method FightCalculation() from Hero class and create the fightLogMessage which reflect on the VF Page
     */
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Head','Head')); 
        options.add(new SelectOption('UpperBody','UpperBody')); 
        options.add(new SelectOption('LowerBody','LowerBody'));
        options.add(new SelectOption('Legs','Legs'));
        return options; 
    }      
    
    public void FightCalculation() 
    {
        
      if (first.getHP() > 0 && second.getHP() > 0 ){
        Integer hitPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
        Integer blockPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
        SelectOption placePCHit = getItems().get(hitPlacePC);
        SelectOption placePCblock = getItems().get(blockPlacePC);
               
        if (hitPlace != placePCBlock.getValue() & blockPlace != placePCHit.getValue())
        {
        List<Integer> damages = hero.fighting(first,second, true, true);
            if (damages.get(0) != 0 & damages.get(1) != 0)
            {
              fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' hit ' + second.Name + ' in the '+
              hitPlace + '\n' + second.Name + ' hit ' + first.Name + ' in the ' +  placePCHit.getValue() + '\n';
            } else if (damages.get(0) != 0 & damages.get(1) == 0)
            {
              fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' hit ' + second.Name + ' in the ' +
              hitPlace + '\n' + second.Name + ' missed'+ '\n';
            } else if (damages.get(0) == 0 & damages.get(1) != 0)
            {
                fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' missed ' + '\n' + 
                second.Name + ' hit ' + first.Name + ' in the ' +  placePCHit.getValue() + '\n';
            } else 
            {
               fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' missed '+
              '\n' + second.Name + ' missed ' + '\n';}
        } else {
            if (hitPlace == placePCBlock.getValue() & blockPlace != placePCHit.getValue())
            {
              List<Integer> damages = hero.fighting(first,second, false, true);
                if (damages.get(1) !=0)
                {
              		fightLogMessage = 'Round ' + RoundNumber + ' - the hit from ' + first.Name + ' was blocked' +
            		'\n' + second.Name + ' hit ' + first.Name + ' in the ' +  placePCHit.getValue() + '\n';
            	} else 
                {
                    fightLogMessage = 'Round ' + RoundNumber + ' - the hit from ' + first.Name + ' was blocked' +
            		'\n' + second.Name + ' missed' + '\n';}
                }
            else
            {
                List<Integer> damages = hero.fighting(first,second, true, false);
                if (damages.get(0) != 0)
                {
                fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' hit ' + second.Name + ' in the ' 
                + hitPlace + '\n' + ' the hit from ' + second.Name + ' was blocked' + '\n';
                } else {
                fightLogMessage = 'Round ' + RoundNumber + ' - ' + first.Name + ' missed ' + '\n' + ' the hit from '
                 + second.Name + ' was blocked' + '\n';   
                }
            }
        }
     
        if (first.getHP() <= 0 & second.getHP() >= 0)
        {
            fightLogMessage = second.Name + ' Win!'; 
            first.setHP(0);
            SelectedHero.Block_Time__c = datetime.now().addDays(1);
            SelectedHero.Stamina__c -= 20;
            update SelectedHero;
            			            
        } else {
            if (first.getHP() >= 0 & second.getHP() <= 0)
            {
                fightLogMessage = first.Name + ' Win!';
                if (SelectedHero.Wins__c != null)
                {
                    SelectedHero.Wins__c ++;
                } else {
                    SelectedHero.Wins__c = 1;
                }
                SelectedHero.Stamina__c -= 20;
                update SelectedHero;           
				second.setHP(0);   
                
            } else {
                if (first.getHP() <= 0 & second.getHP() <= 0)
                {
                    fightLogMessage = 'Both heroes are dead, nobody win)'; 
                    first.setHP(0);
                    second.setHP(0);
                    SelectedHero.Stamina__c -= 20;
                    update SelectedHero;
                }
            }
        }
        }                    
        roundNumber++;             
    }
}