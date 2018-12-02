#include "stdafx.h"
#include "CppUnitTest.h"

#include "Solution.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{
	TEST_CLASS(UnitTest1)
	{
	public:

		TEST_METHOD(TestMethod1)
		{
			//Arrange
			Solution solution_instance;
			vector<string> input = { "abcdef", "bababc","abbcde","abcccd","aabcdd","abcdee","ababab" };
			int expectedOutput = 12;
			//Act
			int realOutput = solution_instance.getCheckSum(input);
			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}

		TEST_METHOD(TestMethod2)
		{
			//Arrange
			Solution solution_instance;
			vector<string> input = { "ayitmcjvlhedbsyoqfzukjpxwt","agirmcjvlheybsyogfzuknpxxt","wgirmcjvlvedbsyoqfzujnpxwt","agizmcjvlhedbsyoqfzuenlxwt","aryrmcjvlheebsyoqfzuknpxwt","agirmcjelhedbsyoqfzukosxwt","azirmcjvlhedbsooqfzuknpxvt","agirmcjvffedbsyoqfzudnpxwt","agilmcjvlhedbsyrqfzuknpxrt","agirmcjvlhndbsyoofzukcpxwt","awirmcjvlhedbsyoqfzuknpxlz","aghrmcjmlhewbsyoqfzuknpxwt","apirmcjvlmedbsyoqfzcknpxwt","jgiricjvlhedbsyrqfzuknpxwt","abirmcjvlbedbsyoqfzuknpxwo","agirmcjvlhedbsyojfzuknpgkt","agicmclvlhedbmyoqfzuknpxwt","aslrzcjvlhedbsyoqfzuknpxwt","agiqmcjvlhedbsymqfzurnpxwt","agirmcjvlwedbsyoqfzuknfxmt","agiumcjvlhedbsyoqfzuknpbyt","xgirxcjvlwedbsyoqfzuknpxwt","bgtrvcjvlhedbsyoqfzuknpxwt","afirmcjvlpedbsyoqvzuknpxwt","agirmcjjvhedbsyoqfzukmpxwt","ggirmcjvlhedbsyoqfzukypxvt","agirmdjulhekbsyoqfzuknpxwt","agirmcjqlhedbsyoqfztknixwt","agirmcjvjhedbsyomfduknpxwt","agirmcjvlhedbgyoqfzuknpxtq","agirmvjvlhbdbsyfqfzuknpxwt","agirmcjvlhedbsyatfzbknpxwt","agirmcjvlrlybsyoqfzuknpxwt","agirmajvlhedbsqovfzuknpxwt","abinmcrvlhedbsyoqfzuknpxwt","agnrmcjvlhedbsyurfzuknpxwt","agirmpjvlhedbsyoqezuknpxct","agirmxjvlhedbsgoqjzuknpxwt","agirmcjvlhehbstoqfzuknpxht","qgirmcjvlhepcsyoqfzuknpxwt","tgirmcjvlhkdbsyoqszuknpxwt","agirmcjvdhedbscoqftuknpxwt","agbrmcjvlhedbsyoqfzukqpxwj","agurmcjvlhedbsyaqfzuknpxmt","agirmcjvohudbsyoqfmuknpxwt","agirmcjvlhekbsyoqfbuktpxwt","agirmcjvlhedhsyoqfzugnnxwt","agirmcjvlhedbsyjqyzuknpxft","agirmcjvlhedbsymufznknpxwt","agirmcjhlheubsyoqfzuknpxmt","agirmcjvlhwdbsywqfzwknpxwt","agirmcjvljedbsgqqfzuknpxwt","aglrmcjelhedbsyoqfzuknpxkt","agxrmcjvlhxdbsyoqfquknpxwt","agirmcjvnhedbsyoqfzuenfxwt","agirmcjvlhedbsyoqfzatnqxwt","agirmcvvlhedbsboqfzuknuxwt","agirncjvlhezbsyoqfzulnpxwt","agiamcjvdiedbsyoqfzuknpxwt","agirmcjvwhedbskoqfzhknpxwt","agiwmcjflhedbsyoqfzulnpxwt","agirmcjvlhedboyoqfzuknpjwl","agivmcjslhedbsyoqfzdknpxwt","agirmcjvlcedbsyoqfzukepxyt","akirmcjvlhjdbssoqfzuknpxwt","agvrmcjvldedmsyoqfzuknpxwt","agirecjvlhidbsyoqfzukbpxwt","abirmcjvlhjdbsyoqfkuknpxwt","agirmcjelhedbfyoqfzuknpxwj","agirmcjvlhedbbyoqrzukwpxwt","akirmcjvlhedbsyoyfzuknplwt","agirmcjvlhedbsydsfzuknpxwq","agirrcjvlhedbsyoqazuknpmwt","aeirmcjvlhedbsyoqfvuknpwwt","akirmcjvlhedbsyoqpzudnpxwt","agijmcjvlhedbsyuqfzunnpxwt","agirmcjilhedasyoqizuknpxwt","agirmczvlhzdbsyoqfzuknpxwx","agirmcjvlhehbsyoifzuknpxwo","agirwcjvlhedbsyoqfzuenpxst","agirmcjvlhedbsyoquzuknhxft","agirmcqvlkedbsyoqfzrknpxwt","agirmcqvlhenbsyoqfzuknpuwt","agirmcjvleedbsyoqfzhhnpxwt","agirmcjvlhembsyrqfauknpxwt","agirmcjvlhedbssoqflcknpxwt","aqirmcjvlnedbsyoqfzuknpxpt","agirmcjqlhedbxpoqfzuknpxwt","fgirmcjvlhedbsyoqfzukqpqwt","aggrmcjvlhpdbsyoqfzuknpxjt","agirmwjvlhedbsywqfzuknpzwt","agirmcailhembsyoqfzuknpxwt","aglrmcjvlhxdbsyoqfzuknpxet","xgirmcjvlhzdbsyoqfzukrpxwt","agvrmcjvuhedbsyoqfzuknpxgt","agikmcjvlhecbsyoqfzuknpxwr","agyrmcjvlhezbsyoqfouknpxwt","agirmcjvfhjdbsyokfzuknpxwt","agkrmjjvlhedtsyoqfzuknpxwt","agirmgjvlhedbiyoqfzuknpxwv","wcirmcjvlhedbsyoqfzuknpxwo","aairmcjvlhedbstoqfguknpxwt","hgirmcjvlhedwfyoqfzuknpxwt","agirmcjvmhfdbmyoqfzuknpxwt","agirmcjvlhvdbsioqfzuanpxwt","agrrmcjvgsedbsyoqfzuknpxwt","agirmcjvlqetbsysqfzuknpxwt","agirccjvlhedbsyoqfzuknkcwt","agirmqjvlhedbsdoqfzkknpxwt","agirmcjvlheobsyopfzuknpxwg","agirmcjolhedbsyofpzuknpxwt","agirmcjnlhedbsyoqkzukfpxwt","agiumcjvlheabsyoqfzuknpxbt","agipmcjvlhedbsyoqfzukupxwz","atirmcrvlhedbsyoqfnuknpxwt","agirmcjvnhedfkyoqfzuknpxwt","agirmrjvlhedboyoqfzvknpxwt","abhrmcjvlhedbtyoqfzuknpxwt","cbirmcjvlhedbfyoqfzuknpxwt","agirmcjvlhedbsyoqfmwknjxwt","ahirmcjvlhedbsloqfzuknpfwt","agarmjjvlhedbsyoqfzyknpxwt","ajirmcjvlhevjsyoqfzuknpxwt","agirmcjvlhpdbstoqfzuknpewt","agirmcsvlhedbsyoqfbupnpxwt","agirmcjvlhexbsyodfzukqpxwt","auiymcjblhedbsyoqfzuknpxwt","azirmcjvchedbsyoqfziknpxwt","aeirmcjvlhedvsyoqfzuonpxwt","agirmcjvlhedbfyoqfbukjpxwt","ygirmcjvlhidbsyoqfzukncxwt","agirmxpvlhedbsyoqffuknpxwt","ztirmcjvlhedosyoqfzuknpxwt","agirmcjvlhepbsyoqfzuenppwt","agirmcjvshedbsyoqnzaknpxwt","awirmcjvlhydbsyoqfzuknoxwt","ucirmcjvlhedbsyoqfjuknpxwt","agirmwjvlhkbbsyoqfzuknpxwt","agirmcjvldedbsyohfzuknpxzt","agirmcjvwhedbsyoqfznknpxgt","agiricjvlhedxqyoqfzuknpxwt","agirmcjvlhzdbjyoqfzukapxwt","agirmcgvlhedbsyoqfzuknaowt","agidmcjvlhedbsyoqayuknpxwt","agirmcjvlhedisnoqfzuknpxnt","wkjrmcjvlhedbsyoqfzuknpxwt","agirmcjvlhedbuyojfzukxpxwt","agkrmcjvlhedbsybqfzurnpxwt","agirmcjvghedbsyoqfzuknexwj","agirmcjvnhedbsyoqfzuznpxit","agirmcjvlbedbsyoqfiukwpxwt","agirlctvlheabsyoqfzuknpxwt","agirmcjzzhedbsyoqfzcknpxwt","akirmcjvlnedbsyoqfzlknpxwt","agirmdjvlhedpsyoqfzuknpjwt","agiyjcuvlhedbsyoqfzuknpxwt","agirmcbvltedysyoqfzuknpxwt","agirmcjvlhedfdyoqfzubnpxwt","agidmcjvlhedesfoqfzuknpxwt","aeirmcjvlhedqsyoqfxuknpxwt","agifmcjvlhedbsyoqfquknptwt","agidmcjvlhedbsyfqfzuknpxwb","agirvcjvlhedbsroqfzuknjxwt","agirmcqvlhddbsyoqfzuknpxwj","agirmcjvlhmdqsyoqizuknpxwt","atirmcjvltedbsyoqfzuknpxwz","agirxnjvlhedbsyoqfzuknpxkt","agihmcjvlhedbsyoqfzukepxqt","agirmcjvlhedbsmoqzsuknpxwt","agirycjvlhedbuyoqfwuknpxwt","agirmcjvlhedbsyoqfzfkrfxwt","agirzcjvlhedbsyoqfhuknpxnt","agigmcjvlhedbsqnqfzuknpxwt","agirmgzvlhedbsyoqfzuonpxwt","agirmcjvqhedbqyoqfzukqpxwt","anarmcjvlhedbsyocfzuknpxwt","agirmcjuihedbshoqfzuknpxwt","agirdckvlhedbsyoqfzxknpxwt","ugirmujvlhwdbsyoqfzuknpxwt","mgirmcjvlheobsyovfzuknpxwt","agirmcjvghedbsyoqfzufxpxwt","agirmcjvlhedbsyoinzuknuxwt","agirmzjvlhbdbsyoqfzlknpxwt","agivmcjvlhedbsconfzuknpxwt","agirmwfvlhedtsyoqfzuknpxwt","agirmcjvlhedbbyoqrzukncxwt","agirmcjvlhelbsyoqfzupnlxwt","agirmmjvluedqsyoqfzuknpxwt","agjrmcjvlhedbsyaqfcuknpxwt","agiwmcjvlhedbsyoqzzuknpswt","agirxcjvlhedbsyoqfyvknpxwt","agirmljvlhedbsyoqkzuknpxjt","agirmcjvchedbsyoqfzmknyxwt","agirmcjvlhedbsyovfzuynpxwl","agtrmcjvlhedysyoqfzuknexwt","agirmcjvmhedbslonfzuknpxwt","agirmcjfshedbsyoqfziknpxwt","agirmcjvlhedbsygqfzkknpbwt","agyrmcivlhedbsyovfzuknpxwt","agirmcjvghedbsyoqjzuknkxwt","agirmcjvlhedqsyoqfzukspxmt","ayirmcjvhhedbsyomfzuknpxwt","agirmcjvlnembsypqfzuknpxwt","agirmcjqlhedbsyuvfzuknpxwt","agirmcjvlhembsybqfzuknpxwa","agirjcfvlhedbsyoqfuuknpxwt","agirmcjvohedbsyowfzuknxxwt","agirmcjvlhedroyoqfzukncxwt","agrrmijvlhedbsyoqfnuknpxwt","agirmjjvlhsdbsyoqfzumnpxwt","agirrcjvnhedbsyoqfzuktpxwt","agirmcjvlzedjsyoqfzuknpdwt","agirmkjvlhedbsyoqfzxinpxwt","agirmcjvlhedbzyojfzuknpvwt","arirmcjvlheddsyoqfzuknrxwt","agirmcjvlhedbsyoqhzuanpxmt","agirmcjvluedbsyoqozuknwxwt","afirmcjwlhedxsyoqfzuknpxwt","agirmcjvlhefbsyoqfkuinpxwt","agirycjvltedbsypqfzuknpxwt","agirmrxvlhedbsyoqfzeknpxwt","agfrmcqvlhedbsyoqxzuknpxwt","agormcjvuhexbsyoqfzuknpxwt","agyrmcjvehddbsyoqfzuknpxwt","agirmcjvlheqbsynqfzgknpxwt","agirmcjvlhedbsloufwuknpxwt","tgirmcjvlwedbsyoqfzuknpqwt","agirmcjvlhesbzyogfzuknpxwt","agitmdjvlhedpsyoqfzuknpjwt","bgirmejvlhtdbsyoqfzuknpxwt","aginmcjvlhedzsyoqfzuknoxwt","agvrzcjvlhedbsuoqfzuknpxwt","agormcjvlhedbsyoqfzuknpodt","agirmcevlhedbgyojfzuknpxwt","agirmcjblhedboytqfzuknpxwt","qgibmcjvlhedbsyoqfzuknbxwt","agirmcjvlhedbsyoafzutnnxwt","agiamcjvchkdbsyoqfzuknpxwt","agirmcjvehedblyoqwzuknpxwt","agirmcpvlhwdbsyoafzuknpxwt","agirmcjvlhtdbsyoqfzumnpxtt","agirmcjalhegtsyoqfzuknpxwt","agirdijvlhedbsyoqfzutnpxwt","agirmckvlhgdbsyovfzuknpxwt","qgmrmcjvlkedbsyoqfzuknpxwt","agirjcjvlhodbsyoqfzuanpxwt","ajirmcjvlhedbpyoqftuknpxwt","cgirmcjvlhedbsyoqfiuonpxwt","ayirmcjvlhedbsyaqfzuknwxwt","agirmcjvlhedbdyoqbzwknpxwt" };
			int expectedOutput = 5434;
			//Act
			int realOutput = solution_instance.getCheckSum(input);
			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
	};
}