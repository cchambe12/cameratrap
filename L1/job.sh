#! /bin/bash
#SBATCH --account=EvolvingAI
#SBATCH --time=167:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH -J USDA18
#SBATCH --mail-type=ALL
#SBATCH --mail-user=michael.a.tabak@aphis.usda.gov
#SBATCH -e USDA18MTN.err
#SBATCH -o USDA18MTN.log
#SBATCH --mem=40360
#SBATCH --gres=gpu:2
cpath=$(pwd)
cd ~
source .bashrc
cd $cpath
python train.py --architecture resnet --depth 18 --path_prefix /lscratch/datasets/usda/ --num_gpus 2 --batch_size 256 --data_info L1WENEW_train2.csv --delimiter , --num_classes 28 --log_dir USDA18MTN
python eval.py --architecture resnet --depth 18  --log_dir USDA18MTN --path_prefix /lscratch/datasets/usda/ --batch_size 512 --data_info L1WENEW_test2.csv --delimiter , --save_predictions USDA18MTN_preds.txt --num_classes 28

#python train.py --architecture resnet --depth 18 --path_prefix /lscratch/datasets/usda/ --num_gpus 2 --batch_size 256 --data_info L1WEN_train.csv --delimiter , --retrain_from USDA18 --num_classes 28 --log_dir USDA182
#python eval.py --architecture resnet --depth 18  --log_dir USDA182 --path_prefix /lscratch/datasets/usda/ --batch_size 512 --data_info L1WEN_test.csv --delimiter , --save_predictions USDA18_preds.txt --num_classes 28
#python train.py --architecture alexnet --path_prefix /project/EvolvingAI/mnorouzz/datasets/imagenet/ --num_gpus 2 --data_info train.txt --batch_size 256 --num_batches 10000
#python eval.py --architecture resnet --depth 18  --log_dir USDA18 --path_prefix /project/iwctml/mnorouzz/ --batch_size 1024 --data_info topredict.csv --delimiter , --save_predictions USDA18_UC_preds.txt --num_classes 28
