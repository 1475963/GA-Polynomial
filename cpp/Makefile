SRC_DIR		=	src/

BUILD_DIR	=	build/

INC_DIR		=	include/

INC 	=	$(INC_DIR:%=-I%)

SRC 	=	$(SRC_DIR)main.cpp

OBJ 	=	$(patsubst $(SRC_DIR)%.cpp, $(BUILD_DIR)%.o, $(SRC))

NAME	=	ga_polynomial

RM	=	rm -f

CC 	=	g++

CXXFLAGS	+=	-W -Wall -Wextra -Werror $(INC) -g

CXXFLAGS	+=	-std=c++11

LDFLAGS 	+=	-lm

$(NAME):	$(OBJ)
	$(CC) $(CXXFLAGS) -o $(NAME) $(OBJ) $(LDFLAGS)

build/%.o:	$(SRC_DIR)%.cpp
		$(CC) $(CFLAGS) -c $^ -o $@

all:	$(NAME)

clean:	
	$(RM) $(OBJ)

fclean:	clean
	$(RM) $(NAME)

re:	fclean all

.PHONY:	all clean fclean re
