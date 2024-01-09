**FREE
/include Api/sources,ErreurApi

// --------------------------------------------------
// Message
// id : Identificateur du message.
// file: Nom du fichier qualifié qui contient le message.
// fileName: Nom du fichier qui contient le message.
// libName: Le nom de la bibliothèque qui contient le fichier de message.
// text: Le texte du message.
// data: Les données du message.
// key: La clé du message. 
// --------------------------------------------------    
DCL-DS Message qualified template;
  id char(7);
  file char(20);
  fileName char(10) overLay(file);
  libName  char(10) overLay(file:*Next);
  text char(132);
  data char(3000);
  key char(4);
END-DS;  

// Méthodes
// --------------------------------------------------
// Nom de la procédure: SndPgmMsg
// Documentation https://www.ibm.com/docs/en/i/7.3?topic=ssw_ibm_i_73/apis/QMHSNDPM.html
// Objectif: Envoyé un message à la file de message du programme
// Retourne:
// Paramètre: id => Identificateur du message
// Paramètre: file => Nom du fichier qualifié qui contient le message
// Paramètre: data => Les données du message
// Paramètre: length => Longueur des données du message
// Paramètre: type => Type du message
// Paramètre: callStack => La pile d'appel
// Paramètre: callStackCtr => Le nombre de ligne de la pile d'appel
// Paramètre: key => La clé du message
// Paramètre: errorForAPI => La structure d'erreur pour l'API
// --------------------------------------------------                  
DCL-PR SndPgmMsg ExtPgm('QMHSNDPM');
  id            char(7) const;
  file          char(20) const;
  data          char(3000) const;
  length        int(10) const;
  type          char(10) const;
  callStack     char(19) const;
  callStackCtr  int(10) const;
  key           char(4);
  errorForAPI   like(ApiError);
END-PR; 

// --------------------------------------------------
// Procedure name: timestampMessageDiagnostic
// Purpose:        Récupére le timestamp du message id demandé
// Returns:        Timestamp du message
// Parameter:      messageSav => Message de diagnostique interrogé
// --------------------------------------------------

// Proécédure de récupération du dernier message de diagnostique du travail
Dcl-Proc timestampMessageDiagnostic export;
  Dcl-Pi *N timestamp;
    messageRecherche LIKEDS(Message) Const;
  End-Pi;

  // Local fields

  Dcl-s timestampMessage timestamp;

  Exec sql
      SELECT a.message_timestamp
        Into :timestampMessage
        FROM TABLE (
            qsys2.joblog_info('*')
                   ) a
       Where a.Message_Id = :messageRecherche.id
    ORDER BY a.message_timestamp DESC
       Limit 1;

    SQLErreur(Sqlca);

    Return timestampMessage;
End-Proc;       