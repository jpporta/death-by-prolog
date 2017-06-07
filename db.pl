%----------------- DEFINES ----------------
voo(sao-paulo, mexico, 2131, 0235, (dia_chegada,horario_chegada), 0, tam, [seg, ter, qua, qui, sex]).
voo(sao-paulo, nova-york, 04502, 2200, (dia_chegada,horario_chegada), 0, gol, [seg, ter, qua, qui, sex]).
voo(sao-paulo, lisboa, 03453, 0700, (dia_chegada,1100), 0, azul, [seg, ter, qua, qui, sex]).
voo(sao-paulo, lisboa, 03882, 0800, (dia_chegada,1300), 0, azul, [seg, ter, qua, qui, sex]).
voo(sao-paulo, madrid, 23404, 0900, (dia_chegada,horario_chegada), 0, tam, [seg, ter, qua, qui, sex]).
voo(sao-paulo, londres, 5605, 1600, (dia_chegada,horario_chegada), 0, gol, [seg, ter, qua, qui, sex]).
voo(sao-paulo, paris, 63216, 2100, (dia_chegada,horario_chegada), 0, azul, [seg, ter, qua, qui, sex]).

%voo(mexico, nova-york, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
%voo(mexico, madrid, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

%voo(nova-york, londres, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

%voo(londres, lisboa, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
%voo(londres, paris, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
%voo(londres, estocolmo, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

%voo(madrid, paris, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
%voo(madrid, roma, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(madrid, frankfurt, 6666, partida,(dia_chegada,horario_chegada), 0, companhia,[dias]).

voo(frankfurt, estocolmo, 7777,partida,(dia_chegada,horario_chegada), 0, companhia,[dias]).
voo(frankfurt, london, 0101, 3,(mesmo,7), 0, tam,[seg,ter,qua]).
voo(frankfurt, london, 1112, 6,(mesmo,9), 0, gol,[qua,qui]).
%voo(frankfurt, roma, codigo,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).





%----------------- FUNÇÕES ----------------
%voo(origem,destino,código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

	conc([], L, L).
	conc([X|L1], L2, [X|L]):-
		conc(L1, L2, L).

	pertence(X, [X|_]).
	pertence(X, [_|Cauda]):-
		pertence(X, Cauda).



% 1- (1 ponto) Verificar se eh possivel ir de uma cidade a outra sem escalas   ####### DONE ########
%?- vôo_direto(Origem, Destino, Companhia, Dia, Horário).

	voo_direto(Origem, Destino, Companhia, Dia, Horario):-
		voo(Origem, Destino, _, Horario, _, 0, Companhia, Dia).

% 2-	(1,5 pontos) É possível viajar de uma cidade X a outra Y, ainda que seja necessário fazer conexões? Independente do tempo da conexão (poderia ser de até uma semana). A sua função deve retornar a lista códigos de vôos que serão realizados.
% ####### DONE ########
	roteiro(Origem, Destino, ListaVoos) :-
		voo(Origem, Destino, Cod, _, _, 0, _, _),
		conc([], Cod, ListaVoos).

	roteiro(Origem, Destino, ListaVoos) :-
		voo(Origem, X, Cod1, _, _, _, _, _),
		roteiro(X, Destino, Lista),
		conc([Cod1|[]], Lista, ListaVoos).

% 3-	(1,5 pontos) Existe vôo direto entre duas cidades, num determinado dia da semana? A sua consulta deve retornar o dia da semana, o horário de saída, o horário de chegada e a companhia.
% ####### DONE ########

	filtra_voo_dia_semana(Origem,Destino, DiaSemana, HorarioSaida,HorarioChegada,Companhia):-
		voo(Origem, Destino, _, HorarioSaida, (_,HorarioChegada), 0, Companhia, Dias),
		pertence(DiaSemana, Dias).


% 4-	(3 pontos) Qual é o vôo ►direto◄ de menor duração entre duas cidades dadas, num determinado dia da semana? Sua consulta deve retornar dia da semana, horário de saída, horário de chegada e a companhia.
% ?-menorDuracao(Origem,Destino,dia,HorarioSaida,HorarioChegada,Companhia)

  listaVoosDiretos(X,X,[]).
  listaVoosDiretos(Origem, Destino, _, L) :-
    findall(Codigo, voo(Origem, Destino, Codigo, _, (_, _), 0, _, _), L).


	menorDuracao(Origem,Destino,Dia,HorarioSaida,HorarioChegada,Companhia) :-
		%voo_direto(Origem, Destino, Companhia, Dia, HorarioSaida).
		listaVoosDiretos(Origem, Destino, Dia, L),
    calculaMenorDuracao(L, Dia, HorarioSaida, HorarioChegada, Companhia, _).


%nao funciona se formato 8:00, mas sim com 800.
  calculaMenorDuracao([], _, _, _, _, 10000000).
  calculaMenorDuracao([H|T], Dia, Partida, Chegada, Companhia, Duracao) :-
    calculaMenorDuracao(T, _, _, _, _, DuraResto),
    voo(_, _, H, Partida, (_, Chegada),_ ,Companhia, Dia),
    Chegada - Partida =< DuraResto,
    Duracao is Chegada - Partida.

  calculaMenorDuracao([H|T], Dia, HorarioSaida, HorarioChegada, Companhia, Duracao) :-
    calculaMenorDuracao(T, Dia, HorarioSaida, HorarioChegada, Companhia, Duracao),
    voo(_, _, H, Partida, (_, Chegada),_, _, _),
    Chegada - Partida > Duracao.


% 5-	(3 pontos) Idem ao anterior, mostrando o dia e horário de partida e a duração total da viagem.
%  menor_roteiro(Origem, Destino, DiaSaída, HorSaida, Duração).
