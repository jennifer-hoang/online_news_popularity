# Online News Popularity
# author: Jennifer Hoang, Nagraj Rao, Linhan Cai
# date: 2021-12-04

all: doc/report.html

# Download data
data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv : src/download_zip.R
	Rscript src/download_zip.R --url='https://archive.ics.uci.edu/ml/machine-learning-databases/00332/OnlineNewsPopularity.zip' --file_path='data/raw'

# Process data
data/processed/OnlineNewsPopularity_clean.csv : data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv src/onp_data_preprocess.py
	python src/onp_data_preprocess.py --raw_data='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --out_dir='data/processed'

# Create EDA plots
results/figures/01_EDA-Bar-Plot-Data-Channel.png results/figures/02_EDA-Shares-Histogram.png results/figures/03_EDA-Correlation-Plot.png : data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv src/eda.py
	mkdir results/figures
	python src/eda.py --data_path='data/raw/OnlineNewsPopularity/OnlineNewsPopularity.csv' --figures_path='results/figures'

# Run R regression analysis
results/tables/mlr_backstep_tidy.rds results/tables/mlr_backstep_glance.rds results/figures/ Figure_1.png Figure_2.png Figure_3.png : data/processed/OnlineNewsPopularity_clean.csv src/regression_online_news_popularity.R
	mkdir results/tables
	Rscript src/regression_online_news_popularity.R --in_file='data/processed/OnlineNewsPopularity_clean.csv' --out_dir='results/tables' --figures_dir='results/figures'

# Create report
doc/report.html : results/figures/01_EDA-Bar-Plot-Data-Channel.png results/figures/02_EDA-Shares-Histogram.png results/figures/03_EDA-Correlation-Plot.png results/tables/mlr_backstep_tidy.rds results/tables/mlr_backstep_glance.rds results/figures/Figure_1.png results/figures/Figure_2.png results/figures/Figure_3.png doc/report.Rmd doc/online_news_pop.bib
	Rscript -e "rmarkdown::render('doc/report.Rmd', output_format = 'html_document')"

clean: 
	rm -rf data/raw 
	rm -rf data/processed/OnlineNewsPopularity_clean.csv
	rm -rf results/tables
	rm -rf results/figures
	rm -rf doc/report.html