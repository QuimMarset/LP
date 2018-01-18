#include <iostream>
#include <vector>
#include <string>
#include <math.h>
using namespace std;




typedef struct {
	int unitat;
	string simbol;
} Component;


void draw(vector <Component> definicio, int altura,vector <int> comencaments) {

	bool espaiNecessari = false;
    bool pic;
    int alturaComencamentPujada,alturaComencamentBaixada,alturaComencamentCentre;

    for (int j = altura+1;j >= 0;--j) { 
        for (int i = 0;i < definicio.size();i+= 3) {
            if (definicio[i].simbol == "/") {
                pic = true;
                alturaComencamentPujada = comencaments[i/3] + 1;
                alturaComencamentBaixada = alturaComencamentPujada + definicio[i].unitat - 1;
                alturaComencamentCentre = alturaComencamentPujada + definicio[i].unitat;
            }
            else {
                pic = false;
                alturaComencamentBaixada = comencaments[i/3];
                if (definicio.size() == 3) 
                	alturaComencamentBaixada++;
                alturaComencamentPujada = alturaComencamentBaixada - definicio[i].unitat + 1;
                alturaComencamentCentre = alturaComencamentBaixada - definicio[i].unitat;
            }
            for (int unitat1 = 0;unitat1 < definicio[i].unitat;++unitat1) {
                if (pic) {
                    if (alturaComencamentPujada + unitat1 == j) 
                        cout << "/";                    
                    else 
                        cout << " ";
                }
                else {
                    if (alturaComencamentBaixada - unitat1 == j) 
                        cout << "\\";                   
                    else 
                        cout << " ";
                }
            }
            for (int unitat2 = 0;unitat2 < definicio[i+1].unitat;++unitat2) {
                if (alturaComencamentCentre == j) {
                    cout << "-";
                    if (!pic and j == 0)
                        espaiNecessari = true;
                }
                else 
                    cout << " ";
            }
            for (int unitat3 = 0;unitat3 < definicio[i+2].unitat;++unitat3) {
                if (pic) {
                    if (alturaComencamentBaixada - unitat3 == j)
                        cout << "\\";                   
                    else 
                        cout << " ";
                }
                else {
                    if (alturaComencamentPujada + unitat3 == j) 
                        cout << "/";            
                    else 
                        cout << " ";
                }
            }
        }
        cout << endl;
    }
    if (espaiNecessari) 
        cout << endl;
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
	int altura;
	cin >> altura;
	vector <int> comencaments(num);
	for (int i = 0;i < num;++i) {
		cin >> comencaments[i];
	}
	draw(muntanya,altura,comencaments);

}