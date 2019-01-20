TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
echo $TF_INC

TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')

CUDA_PATH=/usr/local/cuda

cd hard_label_layer

nvcc -std=c++11 -c -o hard_label_op.cu.o hard_label_op_gpu.cu.cc \
	-I $TF_INC -I$TF_INC/external/nsync/public -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -arch=sm_50

/usr/bin/g++ -std=c++11 -shared -o hard_label.so hard_label_op.cc \
	hard_label_op.cu.o -I $TF_INC -I$TF_INC/external/nsync/public -fPIC -lcudart -lcublas -L $CUDA_PATH/lib64 -L$TF_LIB -ltensorflow_framework

cd ..
echo 'hard_label_layer'