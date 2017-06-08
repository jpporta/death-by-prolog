%----------------- DEFINES ----------------
%Sao Paulo.

vôo(sao_paulo, mexico, h32, 02:35, (dia_chegada,8:14), 0, tam, [seg, ter, qua, qui, sex]).
vôo(sao_paulo, nova_york, k312, 22:00, (dia_chegada,7:43), 0, gol, [seg, ter, qua, qui, sex]).
vôo(sao_paulo, lisboa, h53, 07:00, (dia_chegada,1100), 0, azul, [seg, ter, qua, qui, sex]).
vôo(sao_paulo, madrid, j76, 09:00, (dia_chegada,17:56), 0, tam, [seg, ter, qua, qui, sex]).
vôo(sao_paulo, londres, i84, 16:00, (dia_chegada,20:12), 0, gol, [seg, ter, qua, qui, sex]).
vôo(sao_paulo, paris, n76, 21:00, (dia_chegada,23:45), 0, azul, [seg, ter, qua, qui, sex]).

%Mexico.
vôo(mexico, nova_york, g84 ,10:00,(dia_chegada,12:15), 0, azul,[ter,qui]).
vôo(mexico, madrid, y69,17:45,(dia_chegada,23:50), 0, gol,[ter,qua,qui]).

%Nova York

vôo(nova_york, londres, s32,14:34,(dia_chegada,19:32), 0, tam,[sex, sab, dom]).

%londres

vôo(londres, lisboa, k76,13:20,(dia_chegada,16:13), 0, gol,[ter,qua]).
vôo(londres, paris, i32,12:45,(dia_chegada,14:50), 0, azul,[qui,sex]).
vôo(londres, estocolmo, s89,11:54,(dia_chegada,15:39), 0, tam,[sab]).

%madrid

vôo(madrid, paris, l389,2:21,(dia_chegada,4:32), 0, gol,[dias]).
vôo(madrid, roma, n731,5:74,(dia_chegada,9:12), 0, azul,[dias]).
vôo(madrid, frankfurt, k6666, 9:23,(dia_chegada,14:47), 0, tam,[dias]).

%frankfurt

vôo(frankfurt, estocolmo, t83, 21:55,(dia_chegada,23:55), 0, gol,[seg]).
vôo(frankfurt, roma, b73 ,8:12,(dia_chegada,10:43), 0, azul,[ter]).




%----------------- FUNÇÕES ----------------
%vôo(origem,destino,código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

	conc([], L, L).
	conc([X|L1], L2, [X|L]):-
		conc(L1, L2, L).

	pertence(X, [X|_]).
	pertence(X, [_|Cauda]):-
		pertence(X, Cauda).



% 1- (1 ponto) Verificar se eh possivel ir de uma cidade a outra sem escalas   ####### DONE ########
%?- vôo_direto(Origem, Destino, Companhia, Dia, Horário).

	vôo_direto(Origem, Destino, Companhia, Dia, Horario):-
		vôo(Origem, Destino, _, Horario, _, 0, Companhia, Dia).

% 2-	(1,5 pontos) É possível viajar de uma cidade X a outra Y, ainda que seja necessário fazer conexões? Independente do tempo da conexão (poderia ser de até uma semana). A sua função deve retornar a lista códigos de vôos que serão realizados.
% ####### DONE ########
	roteiro(Origem, Destino, ListaVoos) :-
		vôo(Origem, Destino, Cod, _, _, 0, _, _),
    conc([], [Cod], ListaVoos).

	roteiro(Origem, Destino, ListaVoos) :-
		vôo(Origem, X, Cod1, _, _, 0, _, _),
    roteiro(X, Destino, Lista),
    conc([Cod1], Lista, ListaVoos).



% 3-	(1,5 pontos) Existe vôo direto entre duas cidades, num determinado dia da semana? A sua consulta deve retornar o dia da semana, o horário de saída, o horário de chegada e a companhia.
% ####### DONE ########

	filtra_voo_dia_semana(Origem,Destino, DiaSemana, HorarioSaida,HorarioChegada,Companhia):-
		vôo(Origem, Destino, _, HorarioSaida, (_,HorarioChegada), 0, Companhia, Dias),
		pertence(DiaSemana, Dias).


% 4-	(3 pontos) Qual é o vôo ►direto◄ de menor duração entre duas cidades dadas, num determinado dia da semana? Sua consulta deve retornar dia da semana, horário de saída, horário de chegada e a companhia.
% ?-menorDuracao(Origem,Destino,dia,HorarioSaida,HorarioChegada,Companhia)

  listaVoosDiretos(X,X,[]).
  listaVoosDiretos(Origem, Destino, L) :-
    findall(Codigo, vôo(Origem, Destino, Codigo, _, (_, _), 0, _, _), L).


	menorDuracao(Origem,Destino,Dia,HorarioSaida,HorarioChegada,Companhia) :-
		%vôo_direto(Origem, Destino, Companhia, Dia, HorarioSaida).
		listaVoosDiretos(Origem, Destino, L),
    calculaMenorDuracao(L, Dia, HorarioSaida, HorarioChegada, Companhia, _).


%nao funciona se formato 8:00, mas sim com 800.
  calculaMenorDuracao([], _, _, _, _, 10000000).
  calculaMenorDuracao([H|T], Dia, Partida, Chegada, Companhia, Chegada - Partida) :-
    calculaMenorDuracao(T, _, _, _, _, DuraResto),
    vôo(_, _, H, Partida, (_, Chegada),_ ,Companhia, Dia),
    Chegada - Partida =< DuraResto.

  calculaMenorDuracao([H|T], Dia, HorarioSaida, HorarioChegada, Companhia, Duracao) :-
    calculaMenorDuracao(T, Dia, HorarioSaida, HorarioChegada, Companhia, Duracao),
    vôo(_, _, H, Partida, (_, Chegada),_, _, _),
    Chegada - Partida > Duracao.


% 5-	(3 pontos) Idem ao anterior, mostrando o dia e horário de partida e a duração total da viagem.
%  menor_roteiro(Origem, Destino, DiaSaída, HorSaida, Duração).

  roteiro(Origem, Destino, DiaSaida, HorSaida, Hora:Minuto):-
    findall(Lista,roteiro(Origem, Destino, Lista), Voos),
    menor_roteiro(Voos, DiaSaida, HorSaida, Minutos),
    horaMinuto(Hora, Minuto, Minutos).

  menor_roteiro([], fail, fail, 99999999).
  menor_roteiro([Lista|Tail], Dia, Hora, Min):-
    menor_roteiro(Tail, Dia, Hora, Min),
    calculaRoteiro(Lista, Min1),
    Min1 < Min, !.

  menor_roteiro([[H|T]|Tail], Dia, Hora, Min):-
    menor_roteiro(Tail, _, _, Min1),
    vôo(_,_, H, Hora, _, _, _, Dia),
    calculaRoteiro([H|T], Min),
    Min1 >= Min, !.


  calculaRoteiro([], 0).
  calculaRoteiro([H|T], Min):-
    vôo(_, _, H, HP:MP, (_, HC:MC),_ ,_, _),
    minutoHora(HP, MP, MinP),
    minutoHora(HC, MC, MinC),
    Duracao is MinC - MinP,
    calculaRoteiro(T, Resto),
    Min is Resto + Duracao.



  minutoHora(0, M, M).
  minutoHora(H, M, Min):-
    H1 is H - 1,
    minutoHora(H1, M, Min1),
    Min is Min1 + 60,!.

  horaMinuto(0, M, M):-
    M < 60,!.
  horaMinuto(H, M, Min):-
    Min1 is Min - 60,
    horaMinuto(H1, M, Min1),
    H is H1 + 1.
