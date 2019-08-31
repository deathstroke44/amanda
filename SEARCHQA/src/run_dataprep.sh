train_data=$1
dev_data=$2
test_data=$3
#glovefile=$4 (path of the 300D glove file)

stage=0

if [ $stage -le 0 ]; then
    ## tokenization of the training data
    echo "Tokenizing training data..."
    python3.6 tokenization/do_tokenization.py -in=$train_data -out=data/tokenized-train.json
fi

if [ $stage -le 1 ]; then
   ## tokenization of the dev data
   echo "Tokenizing dev data..."
   python3.6 tokenization/do_tokenization.py -in=$dev_data -out=data/tokenized-dev.json
fi

if [ $stage -le 2 ]; then
   ## tokenization of the test data
   echo "Tokenizing test data..."
   python3.6 tokenization/do_tokenization.py -in=$test_data -out=data/tokenized-test.json
fi

if [ $stage -le 3 ]; then
    ## Download the vocabulary files
    echo "Obtaining the vocabulary files..."
    curl -L -o prep-data/id2word.json https://tinyurl.com/ybdvpxcr/searchqa/id2word.json
    curl -L -o prep-data/id2char.json https://tinyurl.com/ybdvpxcr/searchqa/id2char.json
    ## Alternatively you can follow the src/prep_vocab.py to generate them.

fi

if [ $stage -le 4 ]; then
    ## Indexing the training data for neural network training
    echo "Indexing training data..."
    python prep-data/data_prep_with_char.py -data=data/tokenized-train.json -id2w=prep-data/id2word.json -id2c=prep-data/id2char.json -wr=data/train_indexed.json
fi

if [ $stage -le 5 ]; then
    ## Indexing the dev data for evaluation
    echo "Indexing dev data..."
    python prep-data/data_prep_with_char.py -data=data/tokenized-dev.json -id2w=prep-data/id2word.json -id2c=prep-data/id2char.json -wr=data/dev_indexed.json
fi

if [ $stage -le 6 ]; then
    ## Indexing the test data for evaluation
    echo "Indexing test data..."
    python prep-data/data_prep_with_char.py -data=data/tokenized-test.json -id2w=prep-data/id2word.json -id2c=prep-data/id2char.json -wr=data/test_indexed.json
fi

# Download the embedding matrix
curl -L -o prep-data/embed_mat.npy https://tinyurl.com/ybdvpxcr/searchqa/embed_mat.npy

#if [ $stage -le 7 ]; then
    ## Alternatively prepare the embedding matrix
#   # echo "Preparing embed mat (Optional)..."
#    python prep-data/prep_embed_mat.py -id2w=data/id2word.json -glove $glovefile -out data/embed_mat_opt.npy
#fi

