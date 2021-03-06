.SUFFIXES = .cpp .o

WICWIU_LIB = lib/libwicwiu.a
CFLAGS = -O2 -std=c++11


#	if CUDA device, cuda or cuDNN is not installed, disable the following line
ENABLE_CUDNN = -D__CUDNN__

#	uncomment the following to debug
#DFLAGS = -g -D__DEBUG__


INCLUDE_PATH = -I/usr/local/cuda/include
LIB_PATH = -L. -L/usr/local/cuda/lib64

CC = g++

ifdef	ENABLE_CUDNN
	LINKER = nvcc
	LFLAGS = -lcudart -lcudnn -lpthread
#	LFLAGS = -lpthread
else
	LINKER = g++
	LFLAGS = -lpthread
endif

AR = ar

WICWIU_SRCS = \
	WICWIU_src/Shape.cpp	\
	WICWIU_src/LongArray.cpp	\
	WICWIU_src/Tensor.cpp	\
	WICWIU_src/Operator.cpp	\
	WICWIU_src/LossFunction.cpp	\
	WICWIU_src/Optimizer.cpp	\
	WICWIU_src/Module.cpp	\
	WICWIU_src/NeuralNetwork.cpp


WICWIU_OBJS = ${WICWIU_SRCS:.cpp=.o}

all:	$(WICWIU_LIB)

.cpp.o:
	$(CC) $(CFLAGS) $(DFLAGS) $(ENABLE_CUDNN) $(INCLUDE_PATH) $(LIB_PATH) -c $< -o $@


$(WICWIU_LIB): $(WICWIU_OBJS)
	$(AR) rcs $@ $(WICWIU_OBJS)

#main: $(WICWIU_OBJS) main.o
#	$(LINKER) $(CFLAGS) $(ENABLE_CUDNN) $(DFLAGS) $(LFLAGS) $(INCLUDE_PATH) $(LIB_PATH) -o $@ $(WICWIU_OBJS) main.o

clean:
	rm -rf *.o $(WICWIU_OBJS) $(WICWIU_LIB)
