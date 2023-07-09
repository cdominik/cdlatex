
(defgroup cdlatex-electricindex nil
  "LaTeX electric digit indices."
  :tag "cdlatex-electricindex"
  :link '(url-link :tag "Home Page" "https://github.com/cdominik/cdlatex")
  :prefix "cdlatex-electricindex-"
  :group 'tex)

(defvar cdlatex-electricindex-mode nil
  "Determines if cdlatex-electricindex minor mode is active.")
(make-variable-buffer-local 'cdlatex-electricindex-mode)

(defvar cdlatex-electricindex-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map  "1"        #'cdlatex-electricindex-digit)
    (define-key map  "2"        #'cdlatex-electricindex-digit)
    (define-key map  "3"        #'cdlatex-electricindex-digit)
    (define-key map  "4"        #'cdlatex-electricindex-digit)
    (define-key map  "5"        #'cdlatex-electricindex-digit)
    (define-key map  "6"        #'cdlatex-electricindex-digit)
    (define-key map  "7"        #'cdlatex-electricindex-digit)
    (define-key map  "8"        #'cdlatex-electricindex-digit)
    (define-key map  "9"        #'cdlatex-electricindex-digit)
    (define-key map  "0"        #'cdlatex-electricindex-digit)
    map)
  "Keymap for cdlatex-electricindex minor mode.")

;;;###autoload
(defun turn-on-cdlatex-electricindex ()
  "Turn on cdlatex-electricindex minor mode."
  (cdlatex-electricindex-mode t))

;;;###autoload
(define-minor-mode cdlatex-electricindex-mode
  "Minor mode for electric insertion of numbered indixes.

cdlatex-electricindex is a minor mode supporting fast digit index
insertation in LaTeX math. For example typing x 1 2 will insert
x_{12}.

To turn cdlatex-electricindex Minor Mode on and off in a
particular buffer, use `M-x cdlatex-electricindex-mode'.

To turn on cdlatex-electricindex Minor Mode for all LaTeX files,
add one of the following lines to your .emacs file:

    (add-hook 'latex-mode-hook #'turn-on-cdlatex-electricindex)

This index insertion will only work when the cursor is in a LaTeX
math environment, based on (texmathp). If texmathp is not
available, math math-mode will be assumed.

Entering `cdlatex-electricindex-mode' calls the hook
`cdlatex-electricindex-mode-hook'."
  :lighter " EI")

(defun cdlatex-electricindex-active-here ()
  (if (eq major-mode 'latex-mode)
      (if (fboundp 'texmathp)
          (texmathp)
        t)
    t))
(defun cdlatex-electricindex-digit ()
  "Insert digit, maybe as an index to a quantity in math environment."
  (interactive)
  (if (not (cdlatex-electricindex-active-here))
      (self-insert-command 1)
    (let ((digit (char-to-string (event-basic-type last-command-event))))
      (if (looking-back "[a-zA-Z]" (1- (point)))
          (insert "_" digit " ")
        (if (looking-back "\\(_[0-9]\\) ?" (- (point) 3))
            (progn
              (goto-char (match-beginning 1))
              (forward-char 1)
              (insert "{")
              (forward-char 1)
              (insert digit "}")
              (if (looking-at " ")
                  (forward-char 1)
                (insert " ")))
          (if (looking-back "_{\\([0-9]+\\)} ?"
                            (max (- (point) 10) (point-min)))
              (save-excursion
                (goto-char (match-end 1))
                (insert digit))
            (self-insert-command 1)))))))

