(require 'sample)
(require 'dash)

(ert-deftest my-test ()
  (should (eq sample-foo 'bar)))
(ert-deftest my-other-test ()
  (should (equal (-filter #'zerop '(0 1)) '(0))))
