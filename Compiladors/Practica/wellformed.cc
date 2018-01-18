#include <iostream>
#include <vector>
#include <string>
#include <math.h>
using namespace std;




typedef struct {
	int unitat;
	string simbol;
} Component;


bool wellFormed(vector <Component> muntanya) {

	if (muntanya.size()%3 != 0)
		return false;

	bool wellFormed = true;
	int i = 0;
	while (i < muntanya.size() and wellFormed) {
		if (muntanya[i].simbol == "/") 
			if (muntanya[i+1].simbol != "-" or muntanya[i+2].simbol != "\\")
				wellFormed = false;
		else if (muntanya[i].simbol == "\\")
			if (muntanya[i+1].simbol != "-" or muntanya[i+2].simbol != "/")
				wellFormed = false;

		else
			wellFormed = false;

		i += 3;
	}
	return wellFormed;
}


int main () {

	vector <Component> muntanya;
	int num;
	cin >> num;
	for (int i = 0;i < num;++i) {
		for (int j = 0;j < 3;++j) {
			Component m;
			cin >> m.unitat;
			cin >> m.simbol;
			muntanya.push_back(m);
		}
		
	}
	cout << wellFormed(muntanya);

}
