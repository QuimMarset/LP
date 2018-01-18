#include <iostream>
#include <vector>
#include <string>
#include <math.h>
using namespace std;




typedef struct {
	int unitat;
	string simbol;
} Component;


int height(vector <Component> definicio,vector <int>& comencaments) {

	
	int maxHeight = 0;
	int currentHeight = 0;
	int index = 0;	

	for (int i = 0;i < definicio.size();i += 3) {

		if (definicio[i].simbol == "/") {

			comencaments[index] = currentHeight;
			currentHeight = definicio[i].unitat + currentHeight;
			if (currentHeight > maxHeight) maxHeight = currentHeight;

			currentHeight = currentHeight - definicio[i+2].unitat;
			if (currentHeight < 0) {
				maxHeight = maxHeight + currentHeight*(-1);

				for (int j = 0;j <= index;++j) {
					comencaments[j] += currentHeight*(-1);
				}

				currentHeight = 0;
			}
		}

		else if (definicio[i].simbol == "\\") {
			currentHeight = currentHeight - definicio[i].unitat;
			comencaments[index] = currentHeight;
			if (currentHeight < 0) {
				maxHeight = maxHeight + currentHeight*(-1);
				comencaments[index] = 0;

				for (int j = 0;j < index;++j) {
					comencaments[j] += currentHeight*(-1);
				}

				currentHeight = 0;
			}
			currentHeight += definicio[i+2].unitat;
			if (currentHeight > maxHeight) maxHeight = currentHeight;
		}

		++index;
	}
	return maxHeight;
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
	vector <int> comencaments(num);
	int altura = height(muntanya,comencaments);
	cout << altura << endl;
	for (int i = 0;i < comencaments.size();++i) {
		cout << comencaments[i] << endl;
	}

}