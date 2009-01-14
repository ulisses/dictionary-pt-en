%x PAGE TITLE TEXT CATEGORIA EN
%option stack
        #define MAX 20
        #include <stdlib.h>
        #include <string.h>

        void limpa(char **arr);
        void imprime(char **cat, char *pt, char *en);

        int i = 0;
        char *cat[MAX], *pt=NULL,*en=NULL;
anything .|[\n\t\r]
naoPagina ["Wikipedia""Usuário""Discussão""Ajuda""Anexo""MediaWiki""Categoria"]
%%
"<page>"                        yy_push_state(PAGE);
<PAGE>{
        "<title>"{naoPagina}    yy_pop_state(); // not a valid page
        "<title>"               yy_push_state(TITLE);
        "<text"[^>]+">"         yy_push_state(TEXT);
        "</page>"               yy_pop_state();
        {anything}              /* do nothing */
}

<TEXT>{
        "[["[cC]"ategoria:"     yy_push_state(CATEGORIA);
        "[[en:"                 yy_push_state(EN);
        "</text>"               yy_pop_state();
        {anything}              /* do nothing */
}

<TITLE>{
        [^<]+                   {
                                        i=0;
                                        imprime(cat, pt, en);
                                        limpa(cat);
                                        pt=NULL; en=NULL;
                                        pt=strdup(yytext);
                                }
        "</title>"              yy_pop_state();
        {anything}              /* do nothing */
}

<EN>{
        [^\]]+                  en=strdup(yytext);
        [\]]+                   yy_pop_state();
        "]"\n{anything}         /* do nothing */
}

<CATEGORIA>{
        [ \#\!\*\|]+            yy_pop_state();
        [^\]\|\n]+              {
                                        cat[i]=strdup(yytext);
                                        i++;
                                }
        [\]]+                   yy_pop_state();
        "]"\n{anything}         /* do nothing */
}
{anything}                      /* do nothing */
%%
void limpa(char **arr) {
                int j;
                for(j=0 ; j < MAX ; j++) {
                        arr[j]=NULL;
                }
                return;
}

void imprime(char **cat, char *pt, char *en) {
                int j=0;

                if(cat[0]!=NULL && pt!=NULL && en!=NULL)
                {
                        printf("PT - %s\nEN - %s\n",pt,en);
                        printf("Categoria - %s\n",cat[j]);

                        for(j++ ; cat[j]!=NULL ; j++)
                                printf("            %s\n",cat[j]);
                        puts("");
                }
        }

int main() {
        yylex();
        return 0;
}
