using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Hosting;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Web.Script.Serialization;

namespace MagicSealedSimulator
{

    partial class _Default : Page
    {
        public static List<MagicCard> cardCommonList;
        public static List<MagicCard> cardUncommonList;
        public static List<MagicCard> cardRareList;
        public static List<MagicCard> cardMythicList;
        public static List<MagicCard> cardBasicLandList;
        public static MagicCard card;
        private static readonly Random random = new Random();
        private static readonly object syncLock = new object();
        protected void Page_Load(object sender, EventArgs e)
        {
            setRarityList();
            generateSealedDeck();
            

        }

        public void createBasicLandCard()
        { 

        }

        public void renamePictures()
        {
            DirectoryInfo d = new DirectoryInfo("C:/Users/Kurapika/Documents/MagicSealedSimulator/MagicSealedSimulator/TherosPictures");
            FileInfo[] infos = d.GetFiles();
            foreach (FileInfo f in infos)
            {
                File.Move(f.FullName, f.FullName.ToString().Replace(" ", ""));
            }
        }

        public void createAndAddCardToStack(string name, string color, string type, string cmc, string rarity)
        {
            // create image
            string n = name.Replace(" ", "").Replace("'", "").Replace(",", "").Replace("-", "").Replace("(", "").Replace(")", "");

            Image myImg = new Image();
            myImg.ImageUrl = "~/TherosPictures/" + n + ".jpg";
            myImg.Width = 150;
            myImg.Visible = true;

            HtmlGenericControl li = new HtmlGenericControl("li");
            li.Attributes.Add("file", "/TherosPictures/" + n + ".jpg");
            li.Attributes.Add("name", name);
            li.Attributes.Add("color", color);
            li.Attributes.Add("type", type);
            li.Attributes.Add("cmc", cmc);
            li.Attributes.Add("rarity", rarity);
            li.Attributes.Add("onmouseover", "javascript:return preview(this);");
            li.Controls.Add(myImg);

            
            if (color == "White")
            {
                poolPile1.Controls.Add(li);
            }

            else if (color == "Blue")
            {
                poolPile2.Controls.Add(li);
            }

            else if (color == "Black")
            {
                poolPile3.Controls.Add(li);
            }

            else if (color == "Red")
            {
                poolPile4.Controls.Add(li);
            }

            else if (color == "Green")
            {
                poolPile5.Controls.Add(li);
            }

            else if (color == "MultiColor")
            {
                poolPile6.Controls.Add(li);
            }

            else
            {
                poolPile7.Controls.Add(li);
            }
        }

        public void generateSealedDeck()
        {
            for (int i = 0; i < 6; i++)
            {
                generateBooster(i + 1);
            }

        }

        public void createAndAddFoilToStack(string name, string color, string type, string cmc, string rarity)
        {
            // create image
            string n = name.Replace(" ", "").Replace("'", "").Replace(",", "").Replace("-", "").Replace("(", "").Replace(")", ""); ;

            Image myImg = new Image();
            myImg.ImageUrl = "~/TherosPictures/" + n + ".jpg";
            myImg.Width = 150;
            myImg.Visible = true;

            Image foilImg = new Image();
            foilImg.ImageUrl = "~/Images/foil.png";
            foilImg.Width = 50;
            foilImg.Visible = true;

            HtmlGenericControl li = new HtmlGenericControl("li");
            li.Attributes.Add("file", "/TherosPictures/" + n + ".jpg");
            li.Attributes.Add("name", name);
            li.Attributes.Add("color", color);
            li.Attributes.Add("type", type);
            li.Attributes.Add("cmc", cmc);
            li.Attributes.Add("rarity", rarity);
            li.Attributes.Add("onmouseover", "javascript:return preview(this);");

            HtmlGenericControl div = new HtmlGenericControl("div");
            //div.Attributes.Add("style", "position:relative; top:-70px; left:-20px; border-style: none;");
            foilImg.Attributes.Add("style", "position:relative; top:-210px; left:90px; border-style: none;");
            //div.Controls.Add(foilImg);

            li.Controls.Add(myImg);
            li.Controls.Add(foilImg);
            if (color == "White")
            {
                poolPile1.Controls.Add(li);
            }

            else if (color == "Blue")
            {
                poolPile2.Controls.Add(li);
            }

            else if (color == "Black")
            {
                poolPile3.Controls.Add(li);
            }

            else if (color == "Red")
            {
                poolPile4.Controls.Add(li);
            }

            else if (color == "Green")
            {
                poolPile5.Controls.Add(li);
            }

            else if (color == "MultiColor")
            {
                poolPile6.Controls.Add(li);
            }

            else
            {
                poolPile7.Controls.Add(li);
            }
        }

        // random function
        public static int RandomNumber(int min, int max)
        {
            lock (syncLock)
            { // synchronize
                return random.Next(min, max);
            }
        }

        public void generateBooster(int boosterNr)
        {
            // Generate basic land
            // MagicCard basicland = cardBasicLandList[randomizeRarity(cardBasicLandList.Count)];
            

            // Generate com/unc
            List<int> generatedCommons;
            List<int> generatedUncommons;
            int generatedMythic;
            int generatedRare;

            // If foil, replace commons (common count = 9)
            if (checkFoil() == true)
            {
                generatedCommons = randomizeRarities(cardCommonList.Count, 9);
                MagicCard foilCard = new MagicCard("dummy");
                foilCard = getFoil(foilCard);
                createAndAddFoilToStack(foilCard.Name, foilCard.Color, foilCard.Type, foilCard.CMC, foilCard.Rarity);
            }

            // Else, common count = 10
            else
            {
                generatedCommons = randomizeRarities(cardCommonList.Count, 10);
            }

            generatedUncommons = randomizeRarities(cardUncommonList.Count, 3);

            foreach (int i in generatedCommons)
            {
                createAndAddCardToStack(cardCommonList[i].Name, cardCommonList[i].Color, cardCommonList[i].Type, cardCommonList[i].CMC, cardCommonList[i].Rarity);
            }

            foreach (int j in generatedUncommons)
            {
                createAndAddCardToStack(cardUncommonList[j].Name, cardUncommonList[j].Color, cardUncommonList[j].Type, cardUncommonList[j].CMC, cardUncommonList[j].Rarity);
            }

            // Generate myth/rare
            if (checkMythic() == true)
            {
                generatedMythic = randomizeRarity(cardMythicList.Count);
                createAndAddCardToStack(cardMythicList[generatedMythic].Name, cardMythicList[generatedMythic].Color, cardMythicList[generatedMythic].Type, cardMythicList[generatedMythic].CMC, cardMythicList[generatedMythic].Rarity);
            }

            else
            {
                generatedRare = randomizeRarity(cardRareList.Count);
                createAndAddCardToStack(cardRareList[generatedRare].Name, cardRareList[generatedRare].Color, cardRareList[generatedRare].Type, cardRareList[generatedRare].CMC, cardRareList[generatedRare].Rarity);
            }
            
        }

        // JK
        public static MagicCard getFoil(MagicCard foilcard)
        {
            // 15/63 gives foil
            /* 
            11/16 -> common
            3/16 -> uncommon
            1/16 -> 7/8 -> R AND 1/8 -> M
            1/16 -> L
            */
            int r = RandomNumber(1, 17);

            // C
            if (r >= 1 && r <= 11)
            {
                foilcard = cardCommonList[randomizeRarity(cardCommonList.Count)];
            }

            // Unc
            else if (r >= 12 && r <= 14)
            {
                foilcard = cardUncommonList[randomizeRarity(cardUncommonList.Count)];
            }

            // R
            else if (r == 15)
            {
                // M
                if (checkMythic() == true)
                {
                    foilcard = cardMythicList[randomizeRarity(cardMythicList.Count)];
                }

                else
                {
                    foilcard = cardRareList[randomizeRarity(cardRareList.Count)];
                }

            }

            // L
            else
            {
                foilcard = cardBasicLandList[randomizeRarity(cardBasicLandList.Count)];
            }

            return foilcard;
        }

        // JK
        public static bool checkFoil()
        {
            bool isItFoil = false;
            // 15/63 gives foil
            int r = RandomNumber(1, 64);
            if (r >= 1 && r <= 15)
            {
                isItFoil = true;
            }
            return isItFoil;
        }

        // JK
        public static bool checkMythic()
        {
            bool isItMythic = false;
            int r = RandomNumber(0, 8);
            // Lucky number 7 gives mythic
            if (r == 7)
            {
                isItMythic = true;
            }

            return isItMythic;
        }

        public static void setRarityList()
        {
            cardCommonList = new List<MagicCard>();
            cardUncommonList = new List<MagicCard>();
            cardRareList = new List<MagicCard>();
            cardMythicList = new List<MagicCard>();
            cardBasicLandList = new List<MagicCard>();

            using (StreamReader reader = new StreamReader(HttpContext.Current.Server.MapPath("~/") + "TherosCardList.txt"))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    // Add name to cardNameList
                    if (line.Contains("Name"))
                    {
                        string name = getStringAttribute(line);
                        card = new MagicCard(name);
                        card.Name = name.Trim();
                    }
                        
                    else if (line.Contains("Color"))
                    {
                        string color = getStringAttribute(line);
                        card.Color = color.Trim();

                        if (color.ToLower().Contains("gld"))
                        {
                            card.Color = "MultiColor";
                        }

                        else if (color.ToLower().Contains("w"))
                        {
                            card.Color = "White";
                        }

                        else if (color.ToLower().Contains("u"))
                        {
                            card.Color = "Blue";
                        }

                        else if (color.ToLower().Contains("b"))
                        {
                            card.Color = "Black";
                        }

                        else if (color.ToLower().Contains("r"))
                        {
                            card.Color = "Red";
                        }

                        else if (color.ToLower().Contains("g"))
                        {
                            card.Color = "Green";
                        }

                        else if (color.ToLower().Contains("a"))
                        {
                            card.Color = "Artifact";
                        }

                        else
                        {
                            card.Color = "Land";
                        }
                    }

                    else if (line.Contains("Cost"))
                    {
                        string cost = getStringAttribute(line);
                        card.setConvertedManaCost(cost);
                        card.Cost = cost.Trim();
                    }

                    else if (line.Contains("Type"))
                    {
                        if (string.IsNullOrEmpty(card.Color))
                        {
                            card.Color = "Colorless";
                        }

                        if (line.Contains("Creature"))
                        {
                            card.Type = "Creature";
                        }

                        else
                        {
                            string type = getStringAttribute(line);
                            card.Type = type.Trim();                       
                        }

                    }

                    else if (line.Contains("Rarity"))
                    {
                        string rarity = getStringAttribute(line);
                        card.Rarity = rarity.Trim();

                        if (card.Rarity.Equals("C"))
                        {
                            cardCommonList.Add(card);
                        }

                        else if (card.Rarity.Equals("U"))
                        {
                            cardUncommonList.Add(card);
                        }

                        else if (card.Rarity.Equals("R"))
                        {
                            cardRareList.Add(card);
                        }

                        else if (card.Rarity.Equals("Basic Land"))
                        {
                            cardBasicLandList.Add(card);
                        }

                        else
                        {
                            cardMythicList.Add(card);
                        }
                    }
                }
            }
        }

        public static string getStringAttribute(string textLine)
        {
            string s = textLine;
            s = textLine.Substring(s.LastIndexOf(':') + 1);
            s = s.Replace("\t", String.Empty);
            s.Trim();
            return s;
        }

        // Randomize indexes for any number of cards    JK
        public static List<int> randomizeRarities(int randomSize, int raritySize)
        {
            HashSet<int> check = new HashSet<int>();
            List<int> randomRarityIndexList = new List<int>();
            for (int i = 0; i < raritySize; i++)
            {
                int curValue = RandomNumber(0, randomSize);
                // Check so that the list get unique cards
                while (check.Contains(curValue))
                {
                    curValue = RandomNumber(0, randomSize);
                }

                randomRarityIndexList.Add(curValue);
                check.Add(curValue);

            }
            return randomRarityIndexList;
        }

        // Randomize index for one card (use: foil cards)   JK
        public static int randomizeRarity(int randomSize)
        {
            int randomRarityIndex = new int();
            randomRarityIndex = RandomNumber(0, randomSize);
            return randomRarityIndex;
        }

    }

    public class MagicCard
    {
        public string Name { get; set; }
        public string Color { get; set; }
        public string Cost { get; set; }
        public string Type { get; set; }
        public string Rarity { get; set; }
        char[] ColorSymbols;
        public string CMC { get; set; }

        public MagicCard(string name)
        {
            Name = name;
        }

        public void setConvertedManaCost(string color)
        {
            ColorSymbols = new char[8];
            ColorSymbols = color.ToCharArray();
            int cost = 0;
            int cmc = 0;

            foreach (char c in ColorSymbols)
            {
                if (int.TryParse(c.ToString(), out cost))
                {
                    cmc = cost;
                }

                else
                {
                    cmc++;
                }

            }

            CMC = cmc.ToString();
        }
    }

    public static class JavaScript
    {
        public static string Serialize(object o)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(o);
        }
    }
}











