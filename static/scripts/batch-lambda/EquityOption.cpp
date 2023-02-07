/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*!
 Copyright (C) 2005, 2006, 2007, 2009 StatPro Italia srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <http://quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#include <ql/qldefines.hpp>
#if !defined(BOOST_ALL_NO_LIB) && defined(BOOST_MSVC)
#  include <ql/auto_link.hpp>
#endif
#include <ql/instruments/vanillaoption.hpp>
#include <ql/pricingengines/vanilla/binomialengine.hpp>
#include <ql/pricingengines/vanilla/analyticeuropeanengine.hpp>
#include <ql/pricingengines/vanilla/analytichestonengine.hpp>
#include <ql/pricingengines/vanilla/baroneadesiwhaleyengine.hpp>
#include <ql/pricingengines/vanilla/bjerksundstenslandengine.hpp>
#include <ql/pricingengines/vanilla/batesengine.hpp>
#include <ql/pricingengines/vanilla/integralengine.hpp>
#include <ql/pricingengines/vanilla/fdblackscholesvanillaengine.hpp>
#include <ql/pricingengines/vanilla/mceuropeanengine.hpp>
#include <ql/pricingengines/vanilla/mcamericanengine.hpp>
#include <ql/pricingengines/vanilla/analyticeuropeanvasicekengine.hpp>
#include <ql/time/calendars/target.hpp>
#include <ql/utilities/dataformatters.hpp>
#include <ql/models/shortrate/onefactormodels/vasicek.hpp>

#include <ql/utilities/dataparsers.hpp>

#include <iostream>
#include <iomanip>

using namespace QuantLib;
using namespace std;

#if defined(QL_ENABLE_SESSIONS)
namespace QuantLib {

    ThreadKey sessionId() { return {}; }

}
#endif


std::vector<std::pair<std::string, std::vector<string>>> read_csv(std::string filename);
void MC_simulation(std::vector<std::pair<std::string, std::vector<string>>> & dataset);
void write_csv(std::string filename, std::vector<std::pair<std::string, std::vector<string>>> dataset);

int main(int argc, char* argv[]) {

    try {

        if(argc!=2) {
            cout << "Usage: " << argv[0] << " inputFile" <<endl;
            return 1;
        }
        

        // Read input from a CSV file

        std::cout << "Read input from: " << argv[1] <<std::endl;
        
        std::vector<std::pair<std::string, std::vector<string>>> dataset = read_csv (argv[1]);
        
        MC_simulation (dataset);
        
        write_csv("/tmp/result.csv", dataset);
        
         // End test
        return 0;

    } catch (std::exception& e) {
        std::cerr << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "unknown error" << std::endl;
        return 1;
    }
}

void MC_simulation (std::vector<std::pair<std::string, std::vector<string>>> & dataset) {
    // Calculate American option price with Monte Carlo Method.
    // Go through all the equities from the input file
    // and append the result at the end for each equity after simulations.


    // Add a column for the price result
    dataset.push_back({"price", std::vector<string> {}});
    int priceColIdx = dataset.size() - 1;

    // Do MC simulations for all the Equities
        
    for(int row = 0; row <dataset.at(0).second.size(); row++)
    {
        // set up dates
        Calendar calendar = TARGET();
        Date todaysDate(DateParser::parseFormatted(dataset.at(1).second.at(row),"%m/%d/%Y"));
        Date settlementDate(DateParser::parseFormatted(dataset.at(2).second.at(row),"%m/%d/%Y"));
        Settings::instance().evaluationDate() = todaysDate;

        // our options
        Option::Type type;
        if (dataset.at(3).second.at(row) == "Put")
            type=Option::Put;
        else
            type=Option::Call;
            
        Real underlying = stod(dataset.at(4).second.at(row));  //36
        Real strike = stod(dataset.at(5).second.at(row));  //40
        Spread dividendYield = 0.00;
        Rate riskFreeRate = stod(dataset.at(6).second.at(row)); // 0.06
        Volatility volatility = stod(dataset.at(7).second.at(row)); //0.20
        Date maturity(DateParser::parseFormatted(dataset.at(8).second.at(row), "%m/%d/%Y"));        // (17, May, 1999)
        DayCounter dayCounter = Actual365Fixed();
        std::string method;
        
        std::cout << "Option type = "  << type << std::endl;
        std::cout << "todaysDate = "        << todaysDate << std::endl;
        std::cout << "Maturity = "        << maturity << std::endl;
        std::cout << "Underlying price = "        << underlying << std::endl;
        std::cout << "Strike = "                  << strike << std::endl;
        std::cout << "Risk-free interest rate = " << io::rate(riskFreeRate)
                  << std::endl;
        std::cout << "Dividend yield = " << io::rate(dividendYield)
                  << std::endl;
        std::cout << "Volatility = " << io::volatility(volatility)
                  << std::endl;
        std::cout << std::endl;

        // write column headings
        Size widths[] = { 35, 14, 14, 14 };
        std::cout << std::setw(widths[0]) << std::left << "Method"
                  << std::setw(widths[1]) << std::left << "European"
                  << std::setw(widths[2]) << std::left << "Bermudan"
                  << std::setw(widths[3]) << std::left << "American"
                  << std::endl;
        
        ext::shared_ptr<Exercise> americanExercise(
                                         new AmericanExercise(settlementDate,
                                                              maturity));

        Handle<Quote> underlyingH(
            ext::shared_ptr<Quote>(new SimpleQuote(underlying)));

        // bootstrap the yield/dividend/vol curves
        Handle<YieldTermStructure> flatTermStructure(
            ext::shared_ptr<YieldTermStructure>(
                new FlatForward(settlementDate, riskFreeRate, dayCounter)));
        Handle<YieldTermStructure> flatDividendTS(
            ext::shared_ptr<YieldTermStructure>(
                new FlatForward(settlementDate, dividendYield, dayCounter)));
        Handle<BlackVolTermStructure> flatVolTS(
            ext::shared_ptr<BlackVolTermStructure>(
                new BlackConstantVol(settlementDate, calendar, volatility,
                                     dayCounter)));
        ext::shared_ptr<StrikedTypePayoff> payoff(
                                        new PlainVanillaPayoff(type, strike));
        ext::shared_ptr<BlackScholesMertonProcess> bsmProcess(
                 new BlackScholesMertonProcess(underlyingH, flatDividendTS,
                                               flatTermStructure, flatVolTS));

        // options
        VanillaOption americanOption(payoff, americanExercise);
        

        // Monte Carlo Method: MC (Longstaff Schwartz)
        method = "MC (Longstaff Schwartz)";
        Size mcSeed = 42;
        Size nSamples = 4096;
        ext::shared_ptr<PricingEngine> mcengine3;
        mcengine3 = MakeMCAmericanEngine<PseudoRandom>(bsmProcess)
            .withSteps(100)
            .withAntitheticVariate()
            .withCalibrationSamples(nSamples)
            .withAbsoluteTolerance(0.02)
            .withSeed(mcSeed);
        americanOption.setPricingEngine(mcengine3);
        
        dataset.at(priceColIdx).second.push_back(to_string(americanOption.NPV()));

        std::cout << std::setw(widths[0]) << std::left << method
                  << std::fixed
                  << std::setw(widths[1]) << std::left << "N/A"
                  << std::setw(widths[2]) << std::left << "N/A"
                  << std::setw(widths[3]) << std::left << americanOption.NPV()
                  << std::endl;
        std::cout << std::endl ;
                  
        }

}



#include <string>
#include <fstream>
#include <vector>
#include <utility> // std::pair
#include <stdexcept> // std::runtime_error
#include <sstream> // std::stringstream

std::vector<std::pair<std::string, std::vector<string>>> read_csv(std::string filename){
    // Reads a CSV file into a vector of <string, vector<string>> pairs where
    // each pair represents <column name, column values>

    // Create a vector of <string, int vector> pairs to store the result
    std::vector<std::pair<std::string, std::vector<string>>> result;

    // Create an input filestream
    std::ifstream myFile(filename);

    // Make sure the file is open
    if(!myFile.is_open()) throw std::runtime_error("Could not open file");

    // Helper vars
    std::string line, colname;
    string val;

    // Read the column names
    if(myFile.good())
    {
        // Extract the first line in the file
        std::getline(myFile, line);

        // Create a stringstream from line
        std::stringstream ss(line);

        // Extract each column name
        while(std::getline(ss, colname, ',')){
            
            // Initialize and add <colname, int vector> pairs to result
            result.push_back({colname, std::vector<string> {}});
        }
    }

    // Read data, line by line
    while(std::getline(myFile, line))
    {
        // Create a stringstream of the current line
        std::stringstream ss(line);
        
        // Keep track of the current column index
        int colIdx = 0;
        
        // Extract each integer
        while(std::getline(ss, val, ',')){
            // Add the current value to the 'colIdx' column's values vector
            result.at(colIdx).second.push_back(val);
            
            // If the next token is a comma, ignore it and move on
            if(ss.peek() == ',') ss.ignore();
            
            // Increment the column index
            colIdx++;
        }
    }

    // Close file
    myFile.close();

    return result;
}

void write_csv(std::string filename, std::vector<std::pair<std::string, std::vector<string>>> dataset){
    // Make a CSV file with one or more columns of integer values
    // Each column of data is represented by the pair <column name, column data>
    //   as std::pair<std::string, std::vector<string>>
    // The dataset is represented as a vector of these columns
    
    // Create an output filestream object
    std::ofstream myFile(filename);
    
    // Send column names to the stream
    for(int j = 0; j < dataset.size(); ++j)
    {
        myFile << dataset.at(j).first; 
        if(j != dataset.size() - 1)  // No comma at end of line
          myFile << ","; 
    }
    
    myFile << "\n";
    
    // Send data to the stream
    for(int i = 0; i < dataset.at(0).second.size(); ++i)
    {
        for(int j = 0; j < dataset.size(); ++j)
        {
            myFile << dataset.at(j).second.at(i);
            if(j != dataset.size() - 1) myFile << ","; // No comma at end of line
        }
        myFile << "\n";
    }
    
    // Close the file
    myFile.close();
}

