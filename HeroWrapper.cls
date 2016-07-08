global class HeroWrapper implements Comparable{
    public Hero__c newHero;
	public String Id;
    
		public HeroWrapper(Hero__c best)
        {
            newHero = best;
            id = best.id;
        }
        
        global Integer compareTo(Object compareTo)
        {
         HeroWrapper compareToHero = (HeroWrapper) compareTo;
         Integer returnValue = 0;
            if(newHero.Wins__c > compareToHero.newHero.Wins__c)
            {
                returnValue = -1;
            } else if (newHero.Wins__c < compareToHero.newHero.Wins__c)
            {
                returnValue = 1;
            }
            return returnValue;
        }
}